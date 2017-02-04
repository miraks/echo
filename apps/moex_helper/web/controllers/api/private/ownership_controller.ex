defmodule MoexHelper.Api.Private.OwnershipController do
  use MoexHelper.Web, :controller

  alias MoexHelper.{Ownership, ErrorView}
  alias MoexHelper.OwnershipAction.{Create, Delete}

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def index(conn, _params) do
    ownerships = conn
    |> current_resource
    |> assoc(:ownerships)
    |> preload([:account, :security])
    |> Ownership.not_deleted
    |> Repo.all

    render(conn, "index.json", ownerships: ownerships)
  end

  def create(conn, %{"ownership" => ownership_params}) do
    current_user = current_resource(conn)

    case Create.call(current_user, ownership_params) do
      {:ok, ownership} ->
        render(conn, "show.json", ownership: ownership)
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  def update(conn, %{"id" => id, "ownership" => ownership_params}) do
    changeset = conn
    |> ownerships
    |> Repo.get!(id)
    |> Ownership.changeset(ownership_params)

    case Repo.update(changeset) do
      {:ok, ownership} ->
        render(conn, "show_with_assocs.json", ownership: Repo.preload(ownership, [:account, :security]))
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    conn |> ownerships |> Repo.get!(id) |> Delete.call
    send_resp(conn, 200, "")
  end

  defp ownerships(conn) do
    conn
    |> current_resource
    |> assoc(:ownerships)
  end
end

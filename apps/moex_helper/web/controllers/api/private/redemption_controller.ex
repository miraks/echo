defmodule MoexHelper.Api.Private.RedemptionController do
  use MoexHelper.Web, :controller

  alias MoexHelper.Redemption

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def index(conn, _params) do
    redemptions = conn |> current_resource |> assoc(:redemptions) |> Repo.all
    render(conn, "index.json", redemptions: redemptions)
  end

  def update(conn, %{"id" => id, "redemption" => redemption_params}) do
    changeset = conn
    |> redemptions
    |> Repo.get!(id)
    |> Redemption.changeset(redemption_params)

    case Repo.update(changeset) do
      {:ok, redemption} ->
        render(conn, "show.json", redemption: redemption)
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  defp redemptions(conn) do
    conn
    |> current_resource
    |> assoc(:redemptions)
  end
end

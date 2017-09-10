defmodule MoexHelper.Api.Private.AccountController do
  use MoexHelper.Web, :controller

  alias MoexHelper.{Account, ErrorView}

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def index(conn, _params) do
    accounts = conn |> current_resource |> assoc(:accounts) |> Repo.all
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    changeset = conn
    |> current_resource
    |> build_assoc(:accounts)
    |> Account.changeset(account_params)

    case Repo.insert(changeset) do
      {:ok, account} ->
        render(conn, "show.json", account: account)
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    changeset = conn
    |> accounts
    |> Repo.get!(id)
    |> Account.changeset(account_params)

    case Repo.update(changeset) do
      {:ok, account} ->
        render(conn, "show.json", account: account)
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    conn |> accounts |> Repo.get!(id) |> Repo.delete!
    send_resp(conn, 200, "")
  end

  defp accounts(conn) do
    conn
    |> current_resource
    |> assoc(:accounts)
  end
end

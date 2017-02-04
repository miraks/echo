defmodule MoexHelper.Api.Private.AccountView do
  use MoexHelper.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{accounts: render_many(accounts, __MODULE__, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{account: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      id: account.id,
      name: account.name
    }
  end
end

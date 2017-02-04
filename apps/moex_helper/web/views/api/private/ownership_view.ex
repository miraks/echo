defmodule MoexHelper.Api.Private.OwnershipView do
  use MoexHelper.Web, :view

  alias MoexHelper.Api.Private.{AccountView, SecurityView}

  def render("index.json", %{ownerships: ownerships}) do
    %{ownerships: render_many(ownerships, __MODULE__, "ownership_with_assocs.json")}
  end

  def render("show.json", %{ownership: ownership}) do
    %{ownership: render_one(ownership, __MODULE__, "ownership.json")}
  end

  def render("show_with_assocs.json", %{ownership: ownership}) do
    %{ownership: render_one(ownership, __MODULE__, "ownership_with_assocs.json")}
  end

  def render("ownership.json", %{ownership: ownership}) do
    %{
      id: ownership.id,
      amount: ownership.amount,
      price: ownership.price,
      comment: ownership.comment,
      position: ownership.position
    }
  end

  def render("ownership_with_assocs.json", %{ownership: ownership}) do
    ownership
    |> render_one(__MODULE__, "ownership.json")
    |> Map.merge(%{
      account: render_one(ownership.account, AccountView, "account.json"),
      security: render_one(ownership.security, SecurityView, "security.json")
    })
  end
end

defmodule MoexHelper.Api.Private.CouponController do
  use MoexHelper.Web, :controller

  alias MoexHelper.Coupon

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def index(conn, _params) do
    coupons = conn |> current_resource |> assoc(:coupons) |> Repo.all
    render(conn, "index.json", coupons: coupons)
  end

  def update(conn, %{"id" => id, "coupon" => coupon_params}) do
    changeset = conn
    |> coupons
    |> Repo.get!(id)
    |> Coupon.changeset(coupon_params)

    case Repo.update(changeset) do
      {:ok, coupon} ->
        render(conn, "show.json", coupon: coupon)
      {:error, _changeset} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json")
    end
  end

  defp coupons(conn) do
    conn
    |> current_resource
    |> assoc(:coupons)
  end
end

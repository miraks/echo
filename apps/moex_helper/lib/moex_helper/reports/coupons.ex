defmodule MoexHelper.Reports.Coupons do
  use Timex

  import Ecto.Query

  alias MoexHelper.{Repo, User, Coupon}
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}

  @title "MOEX - Coupons"

  @columns [
    %Column{id: :name, name: "Name"},
    %Column{id: :amount, name: "Amount"},
    %Column{id: :days_past, name: "Days past"},
  ]

  def call(email) do
    User
    |> Repo.get_by!(email: email)
    |> find_coupons
    |> build_report
  end

  defp find_coupons(user) do
    query = from c in Coupon,
      inner_join: o in assoc(c, :ownership),
      inner_join: a in assoc(o, :account),
      inner_join: u in assoc(a, :user),
      where: u.id == ^user.id and not c.collected and c.date <= ^Date.utc_today,
      order_by: c.date

    Repo.all(query)
  end

  defp build_report(coupons) do
    rows = Enum.map(coupons, fn coupon ->
      data = Enum.map(@columns, &value(coupon, &1.id))
      %Row{data: data}
    end)

    %Report{title: @title, columns: @columns, rows: rows}
  end

  defp value(coupon, :name) do
    coupon.name
  end

  defp value(coupon, :amount) do
    coupon.amount
  end

  defp value(coupon, :days_past) do
    left = Timex.diff(Timex.today, coupon.date, :days)
    "#{coupon.date} (#{left})"
  end
end

defmodule MoexHelper.Reports.Ownerships do
  import Ecto
  import Ecto.Query

  import MoexHelper.I18n, only: [t: 1]

  alias Decimal, as: D
  alias MoexHelper.{Repo, User, Ownership}
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}

  @title "MOEX - Securities"

  @columns [
    %Column{id: :account, name: "Account"},
    %Column{id: :code, name: "Code"},
    %Column{id: :secname, name: t("en.security.data.secname")},
    %Column{id: :amount, name: "Amount"},
    %Column{id: :price, name: "Original price"},
    %Column{id: :prevprice, name: t("en.security.data.prevprice")},
    %Column{id: :couponvalue, name: t("en.security.data.couponvalue")},
    %Column{id: :nextcoupon, name: t("en.security.data.nextcoupon")},
    %Column{id: :matdate, name: t("en.security.data.matdate")}
  ]

  def call(email) do
    User
    |> Repo.get_by!(email: email)
    |> load_ownerships
    |> group_ownerships
    |> build_report
  end

  defp load_ownerships(user) do
    user
    |> assoc(:ownerships)
    |> preload([:account, :security])
    |> Ownership.not_deleted
    |> order_by(asc: :position)
    |> Repo.all
  end

  defp group_ownerships(ownerships) do
    ownerships
    |> Enum.chunk_by(fn %{account: account, security: security} -> {account, security} end)
    |> Enum.map(fn ownerships ->
      ownerships
      |> Enum.reduce(fn ownership, result ->
        amount = result.amount + ownership.amount
        price = D.div(
          D.add(
            D.mult(D.new(result.amount), result.price),
            D.mult(D.new(ownership.amount), ownership.price)),
          D.new(amount))
        %{result | amount: amount, price: price}
      end)
      |> Map.update!(:price, &D.round(&1, 2))
    end)
  end

  defp build_report(ownerships) do
    rows = Enum.map(ownerships, fn ownership ->
      data = Enum.map(@columns, &value(ownership, &1.id))
      %Row{data: data, color: color(ownership)}
    end)

    %Report{title: @title, columns: @columns, rows: rows}
  end

  defp color(ownership) do
    left = days_till_coupon(ownership)
    cond do
      left in 0..2 -> "red"
      left in 3..5 -> "orange"
      true -> "black"
    end
  end

  defp value(ownership, :account) do
    ownership.account.name
  end

  defp value(ownership, :code) do
    ownership.security.code
  end

  defp value(ownership, :secname) do
    ownership.security.data["SECNAME"]
  end

  defp value(ownership, :amount) do
    ownership.amount
  end

  defp value(ownership, :price) do
    ownership.price
  end

  defp value(ownership, :prevprice) do
    diff = (prev_price(ownership) - D.to_float(ownership.price)) |> Float.round(2)
    diff_with_sign = if diff > 0, do: "+#{diff}", else: diff
    "#{ownership.security.data["PREVPRICE"]} (#{diff_with_sign})"
  end

  defp value(ownership, :couponvalue) do
    ownership.security.data["COUPONVALUE"]
  end

  defp value(ownership, :nextcoupon) do
    "#{ownership.security.data["NEXTCOUPON"]} (#{days_till_coupon(ownership)})"
  end

  defp value(ownership, :matdate) do
    ownership.security.data["MATDATE"]
  end

  defp days_till_coupon(ownership) do
    ownership.security.data["NEXTCOUPON"] |> Date.from_iso8601! |> Timex.diff(Timex.today, :days)
  end

  defp prev_price(ownership) do
    ownership.security.data["PREVPRICE"]
  end
end

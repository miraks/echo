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
    %Column{id: :next_redemption_amount, name: "Next redemption amount"},
    %Column{id: :next_redemption_at, name: "Next redemption"},
    %Column{id: :matdate, name: t("en.security.data.matdate")},
    %Column{id: :total_value, name: "Total value"}
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
    end) ++ [footer(ownerships)]

    %Report{title: @title, columns: @columns, rows: rows}
  end

  defp footer(ownerships) do
    total_values = ownerships
    |> Enum.reduce(%{}, fn ownership, sums ->
      currency = ownership.security.data["FACEUNIT"]
      total_value = Ownership.total_value(ownership)
      Map.update(sums, currency, total_value, fn sum -> sum + total_value end)
    end)
    |> Enum.map(fn {currency, sum} -> "#{Float.round(sum, 2)} #{t("en.currency_sign.#{currency}")}" end)
    |> Enum.join(", ")

    data = Enum.map(@columns, fn column -> if column.id == :total_value, do: total_values end)
    %Row{data: data}
  end

  defp color(ownership) do
    left = days_till(ownership.security.data["NEXTCOUPON"])
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
    "#{prev_price(ownership)} (#{diff_with_sign})"
  end

  defp value(ownership, :couponvalue) do
    ownership.security.data["COUPONVALUE"]
  end

  defp value(ownership, :nextcoupon) do
    with_days_till(ownership.security.data["NEXTCOUPON"])
  end

  defp value(ownership, :next_redemption_amount) do
    ownership.security.next_redemption_amount
    |> Decimal.to_float
    |> :erlang.float_to_binary(decimals: 2)
  end

  defp value(ownership, :next_redemption_at) do
    with_days_till(ownership.security.next_redemption_at)
  end

  defp value(ownership, :matdate) do
    with_days_till(ownership.security.data["MATDATE"])
  end

  defp value(ownership, :total_value) do
    Ownership.total_value(ownership)
  end

  defp days_till(str) when is_binary(str), do: str |> Date.from_iso8601! |> days_till
  defp days_till(date) do
    Timex.diff(date, Timex.today, :days)
  end

  defp with_days_till(date) do
    "#{date} (#{days_till(date)})"
  end

  defp prev_price(ownership) do
    ownership.security.data["PREVPRICE"]
  end
end

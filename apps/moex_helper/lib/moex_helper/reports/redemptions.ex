defmodule MoexHelper.Reports.Redemptions do
  use Timex

  import Ecto.Query

  alias MoexHelper.{Repo, User, Redemption}
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}

  @title "MOEX - Redemptions"

  @columns [
    %Column{id: :name, name: "Name"},
    %Column{id: :amount, name: "Amount"},
    %Column{id: :days_past, name: "Days past"},
  ]

  def call(email) do
    User
    |> Repo.get_by!(email: email)
    |> find_redemptions
    |> build_report
  end

  defp find_redemptions(user) do
    query = from c in Redemption,
      inner_join: o in assoc(c, :ownership),
      inner_join: a in assoc(o, :account),
      inner_join: u in assoc(a, :user),
      where: u.id == ^user.id and not c.collected and c.date <= ^Date.utc_today,
      order_by: c.date

    Repo.all(query)
  end

  defp build_report(redemptions) do
    rows = Enum.map(redemptions, fn redemption ->
      data = Enum.map(@columns, &value(redemption, &1.id))
      %Row{data: data}
    end)

    %Report{title: @title, columns: @columns, rows: rows}
  end

  defp value(redemption, :name) do
    redemption.name
  end

  defp value(redemption, :amount) do
    redemption.amount
  end

  defp value(redemption, :days_past) do
    left = Timex.diff(Timex.today, redemption.date, :days)
    "#{redemption.date} (#{left})"
  end
end

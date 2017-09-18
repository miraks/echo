defmodule WexWatcher.Reports.Rates do
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}
  alias WexWatcher.Client

  @title "Wex - Exchange rates"

  @columns [
    %Column{id: :currency, name: "Pair"},
    %Column{id: :rate, name: "Rate"}
  ]

  @pairs Application.get_env(:wex_watcher, :pairs)

  def call do
    %Report{title: @title, columns: @columns, rows: rows()}
  end

  defp rows do
    Enum.map(@pairs, fn {from, to} ->
      %Row{data: [
        "#{String.upcase(from)}-#{String.upcase(to)}",
        from |> Client.last_price(to) |> format_price
      ]}
    end)
  end

  defp format_price(price) when is_integer(price), do: price
  defp format_price(price) when is_float(price), do: Float.round(price, 2)
end

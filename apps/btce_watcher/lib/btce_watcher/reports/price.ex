defmodule BtceWatcher.Reports.Price do
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}
  alias BtceWatcher.Client

  @title "BTC-E - Last price"

  @columns [
    %Column{id: :price, name: "Price"}
  ]

  def call do
    %Report{title: @title, columns: @columns, rows: rows()}
  end

  defp rows do
    [
      %Row{data: [Client.last_price]}
    ]
  end
end

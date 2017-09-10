defmodule Cryptoc.Reports.Rates do
  alias Reporter.Report
  alias Reporter.Report.{Column, Row}
  alias Cryptoc.Client

  @title "Crypto - Exchange rates"

  @columns [
    %Column{id: :currency, name: "Currency"},
    %Column{id: :price, name: "Price"}
  ]

  @currencies Application.get_env(:cryptoc, :currencies)

  def call do
    %Report{title: @title, columns: @columns, rows: rows()}
  end

  defp rows do
    Client.rates
    |> Map.take(@currencies)
    |> Enum.map(fn {currency, price} ->
      %Row{data: [currency, format_price(price)]}
    end)
  end

  defp format_price(price) do
    price
    |> String.to_float
    |> (&(1 / &1)).()
    |> Float.round(2)
  end
end

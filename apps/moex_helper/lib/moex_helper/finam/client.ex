defmodule MoexHelper.Finam.Client do
  use HTTPoison.Base

  @base_url "https://bonds.finam.ru"

  def redemptions(code) do
    code
    |> search
    |> Map.get(:body)
    |> get_payments_url
    |> get!
    |> Map.get(:body)
    |> get_redemptions
  end

  defp get_payments_url(html) do
    html
    |> Floki.find("table a[href^='/issue/details'")
    |> hd
    |> Floki.attribute("href")
    |> hd
    |> String.replace(~r/(\/details[^\/]+)/, "\\g{1}00002", global: false)
  end

  defp get_redemptions(html) do
    html
    |> Floki.find("table tr.bline")
    |> Enum.map(fn {_, _, [_, {_, _, [date]}, _, _, _, _, {_, _, [amount]}]} ->
      with {:ok, amount} <- convert_amount(amount),
           {:ok, date} <- convert_date(date),
           do: {amount, date}
    end)
    |> Enum.reject(&(&1 == :error))
  end

  defp search(code) do
    get!("/issue/search/default.asp", [], params: [emitterCustomName: code])
  end

  defp convert_amount(str) do
    case String.trim(str) do
      "" -> :error
      str -> ~r/^[\d,]+/ |> Regex.run(str) |> hd |> String.replace(",", ".") |> Decimal.parse
    end
  end

  defp convert_date(term) when is_tuple(term), do: :error
  defp convert_date(str) do
    [day, month, year] = ~r/\d+/ |> Regex.scan(str) |> Enum.map(fn part -> part |> hd |> String.to_integer end)
    Date.new(year, month, day)
  end

  defp process_url(url) do
    @base_url <> url
  end

  defp process_response_body(body) do
    :iconv.convert("CP1251", "UTF-8", body)
  end
end

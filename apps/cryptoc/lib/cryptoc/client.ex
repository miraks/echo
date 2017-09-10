defmodule Cryptoc.Client do
  use HTTPoison.Base

  @base_url "https://api.coinbase.com/v2"
  @default_headers ["CB-VERSION": "2017-09-10"]

  def rates(currency \\ "USD") do
    "/exchange-rates?currency=#{currency}"
    |> get!
    |> Map.get(:body)
    |> get_in(["data", "rates"])
  end

  defp process_url(url) do
    @base_url <> url
  end

  defp process_request_headers(headers) do
    Keyword.merge(@default_headers, headers)
  end

  defp process_response_body(body) do
    Poison.decode!(body)
  end
end

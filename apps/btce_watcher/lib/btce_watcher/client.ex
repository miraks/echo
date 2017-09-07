defmodule BtceWatcher.Client do
  use HTTPoison.Base

  @base_url "https://btc-e.nz/api/2"

  def last_price do
    "/btc_usd/ticker"
    |> get!
    |> Map.get(:body)
    |> get_in(["ticker", "last"])
  end

  defp process_url(url) do
    @base_url <> url
  end

  defp process_response_body(body) do
    Poison.decode!(body)
  end
end

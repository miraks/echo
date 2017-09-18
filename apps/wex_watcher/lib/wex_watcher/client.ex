defmodule WexWatcher.Client do
  use HTTPoison.Base

  @base_url "https://wex.nz/api/3"

  def last_price(from, to) do
    pair = "#{from}_#{to}"

    "/ticker/#{pair}"
    |> get!
    |> Map.get(:body)
    |> get_in([pair, "last"])
  end

  defp process_url(url) do
    @base_url <> url
  end

  defp process_response_body(body) do
    Poison.decode!(body)
  end
end

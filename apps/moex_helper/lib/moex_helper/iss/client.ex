defmodule MoexHelper.ISS.Client do
  use HTTPoison.Base

  @base_url "https://iss.moex.com/iss"

  def search(query, columns) do
    cache_key = {:search, query, columns}
    get_and_process!(cache_key, "/securities", "securities", columns, q: query, is_trading: 1)
  end

  def security_boards(code, columns) do
    cache_key = {:security_boards, code, columns}
    get_and_process!(cache_key, "/securities/#{code}", "boards", columns)
  end

  def security_data(security, columns) do
    %{board: %{market: %{engine: engine} = market} = board} = security
    cache_key = {:security_data, security.code, columns}
    url = "/engines/#{engine.name}/markets/#{market.name}/boards/#{board.name}/securities/#{security.code}"
    cache_key |> get_and_process!(url, "securities", columns) |> hd
  end

  defp process_url(url) do
    @base_url <> String.replace(url, ~r/\?|$/, ".json\\0", global: false)
  end

  defp process_response_body(body) do
    Poison.decode!(body)
  end

  defp get_and_process!(cache_key, url, block, columns, params \\ []) do
    params = Keyword.merge(params, "iss.meta": "off", "iss.only": block, "#{block}.columns": Enum.join(columns, ","))

    with_cache(cache_key, fn ->
      url
      |> get!([], params: params)
      |> Map.get(:body)
      |> Map.get(block)
      |> merge_columns_and_data
    end)
  end

  defp merge_columns_and_data(body) do
    columns = body["columns"]
    body["data"]
    |> Enum.map(&Enum.into(Enum.zip(columns, &1), %{}))
  end

  defp with_cache(key, fun) do
    case ConCache.get(:iss_cache, key) do
      nil ->
        value = fun.()
        ConCache.put(:iss_cache, key, value)
        value
      value -> value
    end
  end
end

defmodule MoexHelper.Tasks.SyncSecurities do
  import Ecto.Query

  alias MoexHelper.{Repo, Security}
  alias MoexHelper.ISS.Client

  @columns ~W(SECNAME PREVPRICE COUPONVALUE NEXTCOUPON MATDATE)

  def call do
    query = from s in Security,
      preload: [board: [market: :engine]],
      where: is_nil(fragment("to_date(?->>?, 'YYYY-MM-DD')", s.data, "MATDATE")) or
        fragment("to_date(?->>?, 'YYYY-MM-DD')", s.data, "MATDATE") >= ^Date.utc_today

    securities = Repo.stream(query)

    Repo.transaction(fn ->
      Enum.each(securities, &update_data/1)
    end, timeout: :timer.minutes(30))
  end

  defp update_data(security) do
    data = Client.security_data(security, @columns)

    security
    |> Security.changeset(%{data: data})
    |> Repo.update
  end
end

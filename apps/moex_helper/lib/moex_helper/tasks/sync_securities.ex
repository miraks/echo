defmodule MoexHelper.Tasks.SyncSecurities do
  import Ecto.Query

  alias MoexHelper.{Repo, Security}
  alias MoexHelper.ISS.Client

  @columns ~W(SECNAME LOTSIZE PREVPRICE COUPONVALUE NEXTCOUPON MATDATE)

  def call do
    query = from s in Security.not_redeemed,
      preload: [board: [market: :engine]]

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

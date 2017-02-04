defmodule MoexHelper.Tasks.SyncSecurities do
  import Ecto.Query

  alias MoexHelper.{Repo, Security}
  alias MoexHelper.ISS.Client

  @columns ~W(SECNAME PREVPRICE COUPONVALUE NEXTCOUPON MATDATE)

  def call do
    securities = Security |> preload(board: [market: :engine]) |> Repo.stream

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

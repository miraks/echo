defmodule MoexHelper.Tasks.UpdateRedemptionInfo do
  import Ecto.Query

  alias MoexHelper.{Repo, Security}
  alias MoexHelper.Finam.Client

  def call do
    query = from s in Security.not_redeemed,
      inner_join: o in assoc(s, :ownerships), on: is_nil(o.deleted_at),
      distinct: s.id,
      where: is_nil(s.next_redemption_at) or s.next_redemption_at < ^Date.utc_today

    securities = Repo.stream(query)

    Repo.transaction(fn ->
      Enum.each(securities, &update/1)
    end, timeout: :timer.minutes(30))
  end

  defp update(security) do
    [{amount, date} | _] = Client.redemptions(security.code)

    security
    |> Security.changeset(%{next_redemption_amount: amount, next_redemption_at: date})
    |> Repo.update
  end
end

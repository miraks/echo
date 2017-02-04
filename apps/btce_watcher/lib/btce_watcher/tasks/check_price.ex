defmodule BtceWatcher.Tasks.CheckPrice do
  alias Reporter.{Mailer, Email}
  alias BtceWatcher.Client

  @threshold Application.get_env(:btce_watcher, __MODULE__)[:threshold]

  @subject "BTC-E - Price is dropping"

  def call do
    price = Client.last_price
    if price < @threshold, do: send_report()
  end

  defp send_report do
    BtceWatcher.Reports.Price.call
    |> List.wrap
    |> Email.Reports.build(@subject)
    |> Mailer.deliver
  end
end

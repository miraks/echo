defmodule BtceWatcher.Tasks.CheckPrice do
  alias Reporter.{Mailer, Email}
  alias BtceWatcher.Client

  @subject "BTC-E - Price is dropping"

  def call do
    price = Client.last_price
    if price < threshold(), do: send_report()
  end

  defp threshold do
    :btce_watcher
    |> Application.app_dir("priv/price_threshold.secret.txt")
    |> File.read!
    |> String.trim_trailing
    |> String.to_integer
  end

  defp send_report do
    BtceWatcher.Reports.Price.call
    |> List.wrap
    |> Email.Reports.build(@subject)
    |> Mailer.deliver
  end
end

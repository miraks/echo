defmodule WexWatcher.Tasks.CheckPrice do
  alias Reporter.{Mailer, Email}
  alias WexWatcher.Client

  @subject "Wex - Price is dropping"

  def call do
    price = Client.last_price("btc", "usd")
    if price < threshold(), do: send_report()
  end

  defp threshold do
    :wex_watcher
    |> Application.app_dir("priv/price_threshold.secret.txt")
    |> File.read!
    |> String.trim_trailing
    |> String.to_integer
  end

  defp send_report do
    WexWatcher.Reports.Rates.call
    |> List.wrap
    |> Email.Reports.build(@subject)
    |> Mailer.deliver
  end
end

defmodule Reporter.Tasks.EmailStats do
  alias Reporter.{Mailer, Email}

  @email Application.get_env(:reporter, :email)

  def call do
    reports()
    |> Enum.reject(&Enum.empty?(&1.rows))
    |> Email.Reports.build(subject())
    |> Mailer.deliver
  end

  defp reports do
    [
      MoexHelper.Reports.Ownerships.call(@email),
      MoexHelper.Reports.Coupons.call(@email),
      # BtceWatcher.Reports.Price.call
    ]
  end

  defp subject do
    "Stats - #{Timex.today}"
  end
end

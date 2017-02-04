defmodule Reporter.Email.Reports do
  require EEx

  use Timex

  import Swoosh.Email

  @email Application.get_env(:reporter, :email)

  EEx.function_from_file :defp, :body, Path.expand("../templates/email/reports.html.eex", __DIR__), [:reports]

  def build(reports, subject) do
    new \
      from: Application.get_env(:reporter, Reporter.Mailer)[:from],
      to: @email,
      subject: subject,
      html_body: body(reports)
  end
end

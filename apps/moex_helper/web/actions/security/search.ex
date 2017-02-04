defmodule MoexHelper.SecurityAction.Search do
  alias MoexHelper.ISS.Client

  @columns ~W(secid shortname name emitent_title)

  def call(query) do
    Client.search(query, @columns)
    |> Enum.map(fn security ->
      {code, new_security} = Map.pop(security, "secid")
      Map.put(new_security, "code", code)
    end)
  end
end

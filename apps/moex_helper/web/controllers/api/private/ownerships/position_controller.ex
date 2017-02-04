defmodule MoexHelper.Api.Private.Ownerships.PositionController do
  use MoexHelper.Web, :controller

  alias MoexHelper.OwnershipAction.UpdatePositions

  plug Guardian.Plug.EnsureResource, handler: MoexHelper.AuthErrorHandler

  def update(conn, %{"positions" => positions}) do
    current_user = current_resource(conn)

    status = case UpdatePositions.call(current_user, positions) do
      {:ok, _} -> 200
      {:error, _} -> 400
    end

    send_resp(conn, status, "")
  end
end

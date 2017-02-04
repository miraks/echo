defmodule MoexHelper.OwnershipAction.Create do
  @columns ~W(engine market boardid is_primary)

  import Ecto

  alias Ecto.Multi
  alias MoexHelper.{Repo, Engine, Market, Board, Security, Ownership}
  alias MoexHelper.ISS.Client

  def call(user, params) do
    {code, params} = Map.pop(params, "code")
    board = code |> Client.security_boards(@columns) |> get_primary

    multi = Multi.new
    |> Multi.run(:engine, fn _multi -> get_or_create_engine(board["engine"]) end)
    |> Multi.run(:market, &get_or_create_market(&1, board["market"]))
    |> Multi.run(:board, &get_or_create_board(&1, board["boardid"]))
    |> Multi.run(:security, &get_or_create_security(&1, code))
    |> Multi.run(:ownership, &create_ownership(&1, user, params))

    case Repo.transaction(multi) do
      {:ok, %{ownership: ownership}} -> {:ok, ownership}
      {:error, _, value, _} -> {:error, value}
    end
  end

  defp get_primary(boards) do
    Enum.find(boards, &(&1["is_primary"] == 1))
  end

  defp get_or_create_engine(name) do
    case Repo.get_by(Engine, name: name) do
      nil -> %Engine{} |> Engine.changeset(%{name: name}) |> Repo.insert
      engine -> {:ok, engine}
    end
  end

  defp get_or_create_market(%{engine: engine}, name) do
    case Repo.get_by(Market, engine_id: engine.id, name: name) do
      nil -> engine |> build_assoc(:markets) |> Market.changeset(%{name: name}) |> Repo.insert
      market -> {:ok, market}
    end
  end

  defp get_or_create_board(%{market: market}, name) do
    case Repo.get_by(Board, market_id: market.id, name: name) do
      nil -> market |> build_assoc(:boards) |> Board.changeset(%{name: name}) |> Repo.insert
      board -> {:ok, board}
    end
  end

  defp get_or_create_security(%{board: board}, code) do
    case Repo.get_by(Security, board_id: board.id, code: code) do
      nil -> board |> build_assoc(:securities) |> Security.changeset(%{code: code}) |> Repo.insert
      security -> {:ok, security}
    end
  end

  defp create_ownership(%{security: security}, user, params) do
    {account_id, params} = Map.pop(params, "account_id")
    account = Repo.get_by(assoc(user, :accounts), id: account_id)
    params = Map.put(params, "account_id", account.id)

    security
    |> build_assoc(:ownerships)
    |> Ownership.changeset(params)
    |> Repo.insert
  end
end

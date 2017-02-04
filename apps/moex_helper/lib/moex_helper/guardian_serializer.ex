defmodule MoexHelper.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias MoexHelper.{Repo, User}

  def for_token(user = %User{}), do: {:ok, "user:#{user.id}"}
  def for_token(_), do: {:error, "error"}

  def from_token("user:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "error"}
end

defmodule ExChess.Accounts.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias ExChess.Accounts
  alias ExChess.Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "cannot serialize unknown resource"}

  def from_token("User:" <> id), do: {:ok, Accounts.get_user!(id)}
  def from_token(_), do: {:error, "malformed token"}
end

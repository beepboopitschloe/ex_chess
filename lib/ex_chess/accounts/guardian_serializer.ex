defmodule ExChess.Accounts.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias ExChess.Accounts
  alias ExChess.Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "cannot serialize unknown resource"}

  def from_token("User:" <> id) do
    case Accounts.get_user(id) do
      nil -> {:error, :user_missing}
      user -> {:ok, user}
    end
  end
  def from_token(_), do: {:error, :malformed_token}
end

defmodule ExChess.Web.GameChannel do
  use ExChess.Web, :channel

  alias ExChess.Accounts.GuardianSerializer
  alias ExChess.Games
  alias ExChess.Web.GameView
  alias ExChess.Games.Game

  def join("game:" <> game_id, %{ "jwt" => jwt }, socket) do
    with {:ok, token} <- Guardian.decode_and_verify(jwt),
	 {:ok, user} <- GuardianSerializer.from_token(token["sub"]) do

      game = Games.get_game!(game_id)

      case Games.player_join(game, user) do
	{:ok, game} ->
	  socket = assign(socket, :user, user)
	  socket = assign(socket, :game, game)
	  {:ok, GameView.render("game.json", game: game), socket}

	{:error, reason} -> {:error, reason}
      end
    else
      _ -> {:error, "invalid token"}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(%{jwt: jwt}) do
    Guardian.decode_and_verify(jwt)
  end
end

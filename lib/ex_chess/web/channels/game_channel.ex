defmodule ExChess.Web.GameChannel do
  use ExChess.Web, :channel

  require Logger

  alias ExChess.Accounts.GuardianSerializer
  alias ExChess.Games
  alias ExChess.Web.GameView
  alias ExChess.Games.Game

  def join("game:" <> game_id, %{ "jwt" => jwt }, socket) do
    with {:ok, token} <- Guardian.decode_and_verify(jwt),
         {:ok, user} <- GuardianSerializer.from_token(token["sub"]),
         game when game != nil <- Games.get_game(game_id) do

      socket = socket
      |> assign(:user, user)
      |> assign(:game_id, game_id)

      case Games.player_join(game, user) do
        {:ok, game} ->
          send(self(), :after_join)
          {:ok, show_game(game), socket}

        {:error, :game_full} -> {:ok, show_game(game), socket}

        {:error, reason} -> {:error, reason, socket}

        x ->
          Logger.error "unexpected error joining game: #{inspect x}"
          {:error, :server_error, socket}
      end
    else
      nil -> {:error, :game_not_found}
      _ -> {:error, :invalid_token}
    end
  end
  def join("game:" <> _game_id, _, socket) do
    {:error, :missing_token}
  end

  def handle_info(:after_join, socket) do
    %{assigns: %{game_id: id}} = socket
    broadcast_game!(socket, Games.get_game!(id))
    {:noreply, socket}
  end

  def handle_in("send_move", %{"move" => move}, socket) do
    %{assigns: %{user: user, game_id: game_id}} = socket
    game = Games.get_game! game_id

    case Games.player_make_move(game, user, move) do
      {:ok, game} -> reply_game(socket, game)

      {:error, reason} when is_atom(reason) -> reply_error(socket, reason)

      {:error, changeset} ->
        Logger.error "error adding move: #{inspect changeset}"
        reply_error(socket, :server_error)
    end
  end

  def handle_in("get_status", _, socket) do
    %{assigns: %{game_id: game_id}} = socket
    game = Games.get_game!(game_id)
    reply_game(socket, game)
  end

  defp reply_game(socket, game) do
    broadcast_game!(socket, game)
    {:reply, {:ok, show_game(game)}, socket}
  end

  defp reply_error(socket, reason), do: {:reply, {:error, %{reason: reason}}, socket}

  defp broadcast_game!(socket, game), do: broadcast!(socket, "game_updated", show_game(game))

  defp show_game(game), do: GameView.render("game.json", game: game)
end

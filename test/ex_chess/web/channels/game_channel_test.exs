defmodule ExChess.Web.GameChannelTest do
  use ExChess.Web.ChannelCase

  import ExChess.Factory

  alias ExChess.Games
  alias ExChess.Web.UserSocket

  setup do
    game = insert(:game, player_two: nil)
    player_one = game.player_one
    player_two = insert(:user)

    {:ok, socket} = connect(UserSocket, %{})
    {:ok, socket: socket, game: game, player_one: player_one, player_two: player_two}
  end

  defp get_jwt(user) do
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    jwt
  end

  defp join_game(socket, game, user) do
    subscribe_and_join(socket, "game:" <> game.id, %{"jwt" => user |> get_jwt})
  end

  defp join_game!(socket, game, user) do
    subscribe_and_join!(socket, "game:" <> game.id, %{"jwt" => user |> get_jwt})
  end

  test "join a nonexistent game returns an error", %{socket: socket, player_one: player_one} do
    fake_id = Ecto.UUID.generate()
    jwt = player_one |> get_jwt
    assert {:error, :game_not_found} == subscribe_and_join(socket, "game:" <> fake_id, %{"jwt" => jwt})
  end

  test "join without a JWT returns an error", %{socket: socket, game: game} do
    assert {:error, :missing_token} == subscribe_and_join(socket, "game:" <> game.id, %{})
    assert {:error, :invalid_token} == subscribe_and_join(socket, "game:" <> game.id, %{"jwt" => "gobbledegook"})
  end

  test "player join responds with game data", %{socket: socket, game: game, player_one: player_one} do
    {:ok, reply, _} = join_game(socket, game, player_one)
    p1_id = player_one.id

    assert %{"playerOne" => %{"id" => ^p1_id},
	     "status" => "waiting"} = reply

    assert %{player_one_present: true,
	     player_two_present: false} = Games.get_game!(game.id)
  end

  test "status is set to 'playing' after both players join", %{socket: socket, game: game,
							       player_one: player_one,
							       player_two: player_two} do
    join_game!(socket, game, player_one)
    join_game!(socket, game, player_two)

    %{id: game_id} = game
    %{id: player_one_id} = player_one
    %{id: player_two_id} = player_two
    assert_broadcast "game_updated", %{"id" => ^game_id,
				       "playerOne" => %{"id" => ^player_one_id},
				       "playerTwo" => %{"id" => ^player_two_id}}

    assert %{player_one_present: true,
	     player_two_present: true,
	     status: "playing"} = Games.get_game!(game.id)
  end

  test "if game is full, spectators can join without playing", %{socket: socket,
								 game: game,
								 player_one: player_one,
								 player_two: player_two} do
    join_game!(socket, game, player_one)
    join_game!(socket, game, player_two)

    spectator = insert(:user)
    {:ok, reply, spectator_socket} = join_game(socket, game, spectator)

    p1_id = player_one.id
    p2_id = player_two.id

    # assert that spectator is not a player
    assert %{"playerOne" => %{"id" => ^p1_id},
	     "playerTwo" => %{"id" => ^p2_id}} = reply

    # assert that spectator cannot send moves
    move = "e4,e5"
    ref = push spectator_socket, "send_move", %{move: move}
    assert_reply ref, :error, %{reason: :wait_your_turn}
    refute_broadcast "game_updated", %{"moves" => [^move]}
  end

  test "sending a move updates the game and broadcasts the new state", %{socket: socket,
									 game: game,
									 player_one: player_one,
									 player_two: player_two} do
    p1_socket = join_game!(socket, game, player_one)
    join_game!(socket, game, player_two)

    move = "e4,e5"
    ref = push(p1_socket, "send_move", %{"move" => move})
    assert_reply ref, :ok, %{"moves" => [^move],
			     "playerOneTurn" => false}

    assert_broadcast("game_updated", %{"moves" => [^move],
				       "playerOneTurn" => false})
  end

  test "sending a move when it is not your turn returns an error", %{socket: socket,
								     game: game,
								     player_one: player_one,
								     player_two: player_two} do
    join_game!(socket, game, player_one)
    p2_socket = join_game!(socket, game, player_two)

    move = "e4,e5"
    ref = push(p2_socket, "send_move", %{"move" => move})
    assert_reply ref, :error, %{reason: :wait_your_turn}
    refute_broadcast "game_updated", %{"moves" => [^move]}
  end

  test "get_status gets the current status of the game", %{socket: socket,
							   game: game,
							   player_one: player_one} do
    socket = join_game!(socket, game, player_one)

    ref = push(socket, "get_status", nil)
    assert_reply(ref, :ok, %{"playerOnePresent" => true,
			     "playerTwoPresent" => false,
			     "status" => "waiting"})
  end
end

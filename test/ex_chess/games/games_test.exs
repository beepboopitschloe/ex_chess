defmodule ExChess.GamesTest do
  use ExChess.DataCase

  import ExChess.Factory

  alias ExChess.Games

  describe "games" do
    alias ExChess.Games.Game

    @valid_attrs %{moves: [], status: "waiting"}
    @update_attrs %{moves: [], status: "playing"}
    @invalid_attrs %{moves: nil, status: nil}

    test "list_games/0 returns all games" do
      game = insert(:game)
      games = Games.list_games()
      assert length(games) == 1
      assert Enum.at(games, 0).id == game.id
      assert Enum.at(games, 0).status == game.status
    end

    test "list_games_by_status/1 returns games filtered by status" do
      raise "not implemented"
    end

    test "get_game!/1 returns the game with given id" do
      game = insert(:game)
      assert Games.get_game!(game.id).id == game.id
    end

    test "create_game/1 with valid data creates a game" do
      raise "not implemented"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = insert(:game)
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.moves == []
      assert game.status == @update_attrs[:status]
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = insert(:game)
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game.id == Games.get_game!(game.id).id
    end

    test "delete_game/1 deletes the game" do
      game = insert(:game)
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = insert(:game)
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end

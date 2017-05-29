defmodule ExChess.Web.GameControllerTest do
  use ExChess.Web.ConnCase

  alias ExChess.Games
  alias ExChess.Games.Game

  @create_attrs %{moves: [], player_one: "some player_one", player_two: "some player_two", status: "some status"}
  @update_attrs %{moves: [], player_one: "some updated player_one", player_two: "some updated player_two", status: "some updated status"}
  @invalid_attrs %{moves: nil, player_one: nil, player_two: nil, status: nil}

  def fixture(:game) do
    {:ok, game} = Games.create_game(@create_attrs)
    game
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, game_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates game and renders game when data is valid", %{conn: conn} do
    conn = post conn, game_path(conn, :create), game: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, game_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "moves" => [],
      "player_one" => "some player_one",
      "player_two" => "some player_two",
      "status" => "some status"}
  end

  test "does not create game and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, game_path(conn, :create), game: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen game and renders game when data is valid", %{conn: conn} do
    %Game{id: id} = game = fixture(:game)
    conn = put conn, game_path(conn, :update, game), game: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, game_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "moves" => [],
      "player_one" => "some updated player_one",
      "player_two" => "some updated player_two",
      "status" => "some updated status"}
  end

  test "does not update chosen game and renders errors when data is invalid", %{conn: conn} do
    game = fixture(:game)
    conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen game", %{conn: conn} do
    game = fixture(:game)
    conn = delete conn, game_path(conn, :delete, game)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, game_path(conn, :show, game)
    end
  end
end

defmodule ExChess.Web.GameControllerTest do
  use ExChess.Web.ConnCase

  import ExChess.Factory

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", jwt)

    {:ok, conn: conn, user: user}
  end

  test "lists all games", %{conn: conn} do
    game = insert(:game)
    conn = get conn, game_path(conn, :index)
    list = json_response(conn, 200)["data"]
    assert Enum.map(list, &(&1["id"])) == [game.id]
  end

  test "lists games filtered by status", %{conn: conn} do
    playing = insert(:game, status: "playing")

    conn = get conn, game_path(conn, :index, status: "playing")
    list = json_response(conn, 200)["data"]
    assert length(list) == 1
    assert Enum.at(list, 0)["id"] == playing.id
  end

  test "creates a new game with the creator as player one", %{conn: conn, user: user} do
    conn = post conn, game_path(conn, :create)
    created = json_response(conn, 201)["data"]
    assert created["status"] == "waiting"
    assert created["moves"] == []
    assert created["playerOne"]["id"] == user.id
    assert created["playerOneTurn"] == true
    assert created["playerTwo"] == nil
  end
end

defmodule ExChess.Web.GameControllerTest do
  use ExChess.Web.ConnCase

  import ExChess.Factory

  alias ExChess.Games
  alias ExChess.Games.Game

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all games", _ do
    raise "not implemented"
  end

  test "lists games filtered by status", _ do
    raise "not implemented"
  end

  test "creates a new game with the creator as player one", _ do
    raise "not implemented"
  end
end

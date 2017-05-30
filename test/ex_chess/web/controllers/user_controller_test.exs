defmodule ExChess.Web.UserControllerTest do
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

  test "shows a user", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user.id)
    assert json_response(conn, 200)["data"]["id"] == user.id
  end

  test "shows the user's identity", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :identity)
    assert json_response(conn, 200)["data"]["id"] == user.id
  end
end

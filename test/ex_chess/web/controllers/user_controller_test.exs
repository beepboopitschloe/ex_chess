defmodule ExChess.Web.UserControllerTest do
  use ExChess.Web.ConnCase

  alias ExChess.Accounts
  alias ExChess.Accounts.User

  @create_attrs %{password: "some password", username: "some username"}
  @update_attrs %{password: "some updated password", username: "some updated username"}
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)
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

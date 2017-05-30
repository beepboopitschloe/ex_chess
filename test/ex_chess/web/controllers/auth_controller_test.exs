defmodule ExChess.Web.AuthControllerTest do
  use ExChess.Web.ConnCase

  alias ExChess.Accounts

  @username "foobar"
  @password "letmein"

  test "signs up a user and returns a JWT", %{conn: conn} do
    conn = post conn, auth_path(conn, :signup), username: @username, password: @password
    assert %{"identity" => identity,
	     "jwt" => jwt} = json_response(conn, 201)["data"]
    {:ok, %{"sub" => "User:" <> id}} = Guardian.decode_and_verify(jwt)
    assert identity["id"] == id
  end

  test "does not create a user when data is missing", %{conn: conn} do
    conn = post conn, auth_path(conn, :signup), username: @username
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "logs in a user and returns a JWT", %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{username: @username, password: @password})

    conn = post conn, auth_path(conn, :login), username: @username, password: @password
    assert %{"identity" => identity,
	     "jwt" => jwt} = json_response(conn, 200)["data"]
    assert identity["id"] == user.id

    {:ok, %{"sub" => "User:" <> id}} = Guardian.decode_and_verify(jwt)
    assert id == user.id
  end
end

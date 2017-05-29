defmodule ExChess.Web.AuthController do
  use ExChess.Web, :controller

  alias ExChess.Accounts
  alias ExChess.Accounts.User

  plug Guardian.Plug.EnsureNotAuthenticated

  action_fallback ExChess.Web.FallbackController

  def signup(conn, %{"username" => username, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.create_user(username, password) do
      conn = Guardian.Plug.api_sign_in(conn, user)
      jwt = Guardian.Plug.current_token(conn)

      conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("login.json", user: user, jwt: jwt)
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case Accounts.check_login(username, password) do
      %User{} = user ->
	conn = Guardian.Plug.api_sign_in(conn, user)
	jwt = Guardian.Plug.current_token(conn)

	conn
	|> put_status(:ok)
	|> put_resp_header("authorization", "Bearer #{jwt}")
	|> render("login.json", user: user, jwt: jwt)

      nil ->
	conn
	|> put_status(:unauthorized)
	|> render("error.json", message: "authentication failed")
    end
  end
end

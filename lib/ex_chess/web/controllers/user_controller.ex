defmodule ExChess.Web.UserController do
  use ExChess.Web, :controller

  alias ExChess.Accounts
  alias ExChess.Accounts.User

  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureResource

  action_fallback ExChess.Web.FallbackController

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def identity(conn, _) do
    render(conn, "show.json", user: Guardian.Plug.current_resource(conn))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

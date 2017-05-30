defmodule ExChess.Web.GameController do
  use ExChess.Web, :controller

  alias ExChess.Games
  alias ExChess.Games.Game

  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureResource

  action_fallback ExChess.Web.FallbackController

  def index(conn, %{"status" => status}) when status != nil do
    render(conn, "index.json", games: Games.list_games_by_status(status))
  end
  def index(conn, _) do
    render(conn, "index.json", games: Games.list_games())
  end

  def create(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Game{} = game} <- Games.create_game(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", game_path(conn, :show, game))
      |> render("show.json", game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, "show.json", game: game)
  end
end

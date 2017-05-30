defmodule ExChess.Web.GameView do
  use ExChess.Web, :view
  alias ExChess.Web.GameView
  alias ExChess.Web.UserView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    player_one = UserView.render("user.json", %{user: game.player_one})
    player_two = if Ecto.assoc_loaded?(game.player_two) do
      UserView.render("user.json", %{user: game.player_two})
    else
      nil
    end

    %{id: game.id,
      player_one: player_one,
      player_two: player_two,
      status: game.status,
      moves: game.moves}
  end
end

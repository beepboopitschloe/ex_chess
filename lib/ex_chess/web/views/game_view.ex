defmodule ExChess.Web.GameView do
  use ExChess.Web, :view
  alias ExChess.Web.GameView

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: game}) do
    %{id: game.id,
      player_one: game.player_one,
      player_two: game.player_two,
      status: game.status,
      moves: game.moves}
  end
end

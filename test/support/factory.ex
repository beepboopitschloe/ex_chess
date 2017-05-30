defmodule ExChess.Factory do
  use ExMachina.Ecto, repo: ExChess.Repo

  alias ExChess.Accounts.User
  alias ExChess.Games.Game

  def user_factory do
    %User{username: sequence("username"),
	  password: "letmein"}
  end

  def game_factory do
    %Game{player_one: build(:user),
	  player_two: build(:user)}
  end
end

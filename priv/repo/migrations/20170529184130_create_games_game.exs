defmodule ExChess.Repo.Migrations.CreateExChess.Games.Game do
  use Ecto.Migration

  def change do
    create table(:games_games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :player_one, :binary
      add :player_two, :binary
      add :status, :string
      add :moves, {:array, :string}

      timestamps()
    end

  end
end

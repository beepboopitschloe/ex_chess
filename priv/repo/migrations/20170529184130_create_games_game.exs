defmodule ExChess.Repo.Migrations.CreateExChess.Games.Game do
  use Ecto.Migration

  def change do
    create table(:games_games, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :moves, {:array, :string}
      add :status, :string, default: "waiting"
      add :player_one_turn, :boolean, default: true
      add :player_one_present, :boolean, default: false
      add :player_two_present, :boolean, default: false
      add :player_one_id, :binary
      add :player_two_id, :binary

      timestamps()
    end

  end
end

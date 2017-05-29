defmodule ExChess.Repo.Migrations.CreateExChess.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :password, :string

      timestamps()
    end

    create unique_index(:accounts_users, :username)
  end
end

defmodule ExChess.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChess.Games.Game


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games_games" do
    field :moves, {:array, :string}
    has_one :player_one, ExChess.Accounts.User
    has_one :player_two, ExChess.Accounts.User
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs) do
    game
    |> cast(attrs, [:player_one, :player_two, :status, :moves])
    |> validate_required([:player_one, :player_two, :status, :moves])
  end
end

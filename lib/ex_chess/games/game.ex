defmodule ExChess.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChess.Games.Game


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games_games" do
    field :moves, {:array, :string}, default: []
    belongs_to :player_one, ExChess.Accounts.User
    belongs_to :player_two, ExChess.Accounts.User
    field :status, :string, default: "waiting"

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs \\ %{}) do
    game
    |> cast(attrs, [:status, :moves, :player_one_id, :player_two_id])
    |> validate_required([:player_one, :status, :moves])
  end
end

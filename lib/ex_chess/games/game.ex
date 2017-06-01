defmodule ExChess.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExChess.Games.Game


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "games_games" do
    field :moves, {:array, :string}, default: []
    field :status, :string, default: "waiting"
    field :player_one_present, :boolean, default: false
    field :player_two_present, :boolean, default: false
    field :player_one_turn, :boolean, default: true
    belongs_to :player_one, ExChess.Accounts.User
    belongs_to :player_two, ExChess.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Game{} = game, attrs \\ %{}) do
    game
    |> cast(
      attrs, [:status, :moves, :player_one_present, :player_two_present,
	      :player_one_turn, :player_one_id, :player_two_id]
    )
    |> validate_required([:player_one, :status, :moves])
  end
end

defmodule ExChess.Games do
  @moduledoc """
  The boundary for the Games system.
  """

  import Ecto.Query, warn: false
  alias ExChess.Repo

  alias ExChess.Games.Game
  alias ExChess.Accounts.User

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(from Game, preload: [:player_one, :player_two])
  end

  def list_games_by_status status do
    Repo.all(from g in Game,
      where: g.status == ^status,
      preload: [:player_one, :player_two])
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id) |> Repo.preload([:player_one, :player_two])

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%User{})
      {:ok, %Game{player_one: %User{}}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(%ExChess.Accounts.User{id: player_one_id}) do
    %Game{player_one_id: player_one_id}
    |> Repo.preload(:player_one)
    |> Game.changeset
    |> Repo.insert
  end
  def create_game(_) do
    {:error, Game.changeset(%Game{})}
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Attempt to add a player to the game.
  """
  def player_join(%Game{} = game, %User{id: player_id}) do
    case game do
      %Game{player_one: %{id: ^player_id}} ->
	{:ok, game}

      %Game{player_two: %{id: ^player_id}} ->
	{:ok, game}

      %Game{player_two: nil} ->
	update_game(game, %{player_two_id: player_id,
			    status: "playing"})

      _ -> {:error, :game_full}
    end
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end
end

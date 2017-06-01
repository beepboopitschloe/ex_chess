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
  Add a player to the game.
  """
  def player_join(%Game{} = game, %User{} = player) do
    with {:ok, game} <- update_with_player(game, player) do
      case game do
	%Game{player_one_present: true,
	  player_two_present: true} ->
	  update_game(game, %{status: "playing"})

	game -> {:ok, game}
      end
    end
  end

  defp update_with_player(%Game{} = game, %User{id: player_id}) do
    case game do
      %Game{player_one: %{id: ^player_id}} ->
	update_game(game, %{player_one_present: true})

      %Game{player_two: %{id: ^player_id}} ->
	update_game(game, %{player_two_present: true})

      %Game{player_two: nil} ->
	update_game(game, %{player_two_id: player_id,
			    player_two_present: true})

      _ -> {:error, :game_full}
    end
  end

  @doc """
  Append a move as the given player.
  """
  def player_make_move(%Game{} = game, %User{id: player_id} = player, move) when is_binary(move) do
    case game do
      %Game{player_one: %{id: ^player_id}, player_one_turn: true} ->
	update_game(game, %{moves: game.moves ++ [move],
			    player_one_turn: false})

      %Game{player_two: %{id: ^player_id}, player_one_turn: false} ->
	update_game(game, %{moves: game.moves ++ [move],
			    player_one_turn: true})

      _ -> {:error, :wait_your_turn}
    end
  end

  @doc """
  Remove a player from the game.
  """
  def player_leave(%Game{} = game, %User{id: player_id}) do
    case game do
      %Game{player_one: %{id: ^player_id}} ->
	update_game(game, %{player_one_present: false})

      %Game{player_two: %{id: ^player_id}} ->
	update_game(game, %{player_two_present: false})

      _ -> {:error, :player_not_in_game}
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

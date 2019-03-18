defmodule TetrisOtp.Servers.Match do
  @moduledoc """
  GenServer Match process

  @supervisor: TetrisOtp.Supervisors.Match
  """

  use GenServer
  require Logger

  @ptype :n
  @scope :l
  @key __MODULE__

  def lookup(match) do
    match |> term() |> Utils.Gproc.lookup()
  end

  def add_player_into(match, player) do
    {:ok, pid} = lookup(match)

    GenServer.call(pid, {:add_player, player})
  end

  def players_in(match) do
    {:ok, pid} = lookup(match)

    GenServer.call(pid, :players)
  end

  def handle_call({:add_player, player}, _from, state) do
    %{match: match, players: players, max_players: max_players} = state

    if players.names |> Map.keys() |> length() == max_players do
      {:reply, {:error, :match_full}, state}
    else
      # TODO(DZ): Test for if player name exists
      case TetrisOtp.Supervisors.RoomPlayer.start_player(player, match) do
        {:ok, pid} ->
          new_state = add_player_into_state(pid, player, state)
          {:reply, {:ok, pid}, new_state}

        error ->
          {:reply, error, state}
      end
    end
  end

  def handle_call(:players, _from, state) do
    %{players: %{names: names}} = state

    players = Enum.map(names, fn {name, _} -> name end)

    {:reply, players, state}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    new_state = remove_player_from_state(ref, state)
    {:noreply, new_state}
  end

  def child_spec({match, max_players}) do
    %{
      id: match,
      start: {@key, :start_link, [{match, max_players}]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link({match, _} = args) do
    Logger.info("Starting #{@key}: #{match}")
    GenServer.start_link(@key, args, name: {:via, :gproc, term(match)})
  end

  def init({match, max_players}) do
    state = %{
      match: match,
      max_players: max_players,
      players: %{
        names: %{},
        refs: %{}
      }
    }

    {:ok, state}
  end

  defp term(match) do
    {@ptype, @scope, {@key, match}}
  end

  defp remove_player_from_state(ref, state) do
    %{players: %{names: names, refs: refs}} = state

    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)

    %{
      state
      | players: %{
          names: names,
          refs: refs
        }
    }
  end

  defp add_player_into_state(pid, player, state) do
    %{players: %{names: names, refs: refs}} = state
    ref = Process.monitor(pid)

    %{
      state
      | players: %{
          names: Map.put(names, player, ref),
          refs: Map.put(refs, ref, player)
        }
    }
  end
end

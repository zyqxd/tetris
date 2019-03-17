defmodule TetrisOtp.Servers.Room do
  @moduledoc """
  GenServer Room process

  @supervisor: TetrisOtp.Supervisors.Room
  """

  use GenServer

  @ptype :n
  @scope :l
  @key __MODULE__

  def lookup(room) do
    room |> term() |> Utils.Gproc.lookup()
  end

  def add_player_into(room, player) do
    {:ok, pid} = lookup(room)

    GenServer.call(pid, {:add_player, player})
  end

  def players_in(room) do
    {:ok, pid} = lookup(room)

    GenServer.call(pid, :players)
  end

  def handle_call({:add_player, player}, _from, state) do
    # TODO(DZ): Test for if player name exists
    case TetrisOtp.Supervisors.Player.start_player(player) do
      {:ok, pid} ->
        new_state = add_player_into_state(pid, player, state)
        {:reply, {:ok, pid}, new_state}

      error ->
        {:reply, error, state}
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

  def child_spec(room) do
    %{
      id: room,
      start: {@key, :start_link, [room]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link(room) do
    IO.puts("Starting #{@key}: #{room}")
    GenServer.start_link(@key, :ok, name: {:via, :gproc, term(room)})
  end

  def init(:ok) do
    {:ok,
     %{
       players: %{
         names: %{},
         refs: %{}
       }
     }}
  end

  defp term(room) do
    {@ptype, @scope, {@key, room}}
  end

  defp remove_player_from_state(ref, state) do
    %{players: %{names: names, refs: refs}} = state

    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)

    %{
      players: %{
        names: names,
        refs: refs
      }
    }
  end

  defp add_player_into_state(pid, player, state) do
    ref = Process.monitor(pid)
    %{players: %{names: names, refs: refs}} = state

    %{
      players: %{
        names: Map.put(names, player, ref),
        refs: Map.put(refs, ref, player)
      }
    }
  end
end

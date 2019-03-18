defmodule TetrisOtp.Supervisors.RoomPlayer do
  @moduledoc """
  Dynamic Supervisor that starts Player servers

  @supervisor: Application
  @supervises: TetrisOtp.Servers.Player
  """

  use Supervisor
  require Logger

  @ptype :n
  @scope :l
  @key __MODULE__
  @supervises TetrisOtp.Servers.Player

  def lookup(room) do
    room |> term() |> Utils.Gproc.lookup()
  end

  def child_spec(room) do
    %{
      id: {@key, room},
      start: {@key, :start_link, [room]},
      restart: :temporary,
      type: :supervisor
    }
  end

  def start_link(room) do
    Logger.info("Starting #{@key}: #{room}")
    Supervisor.start_link(@key, :ok, name: {:via, :gproc, term(room)})
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def start_player(player, room) do
    {:ok, pid} = lookup(room)
    Supervisor.start_child(pid, {@supervises, {player, room}})
  end

  def children(room) do
    {:ok, pid} = lookup(room)

    Supervisor.which_children(pid)
  end

  defp term(room) do
    {@ptype, @scope, {@key, room}}
  end
end

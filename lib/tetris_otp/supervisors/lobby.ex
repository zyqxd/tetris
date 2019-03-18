defmodule TetrisOtp.Supervisors.Lobby do
  @moduledoc """
  Dynamic Supervisor that starts Lobby servers

  @supervisor: Application
  @supervises: TetrisOtp.Supervisors.Room
  """

  use Supervisor
  require Logger

  @key __MODULE__
  @supervises TetrisOtp.Supervisors.Room

  def start_link([]) do
    Logger.info "Starting #{@key}"
    Supervisor.start_link(@key, :ok, name: @key)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def start_room(room, max_players) do
    Supervisor.start_child(@key, {@supervises, {room, max_players}})
  end

  def start_room(room) do
    Supervisor.start_child(@key, {@supervises, {room, 100}})
  end

  def children do
    Supervisor.which_children(@key)
  end
end

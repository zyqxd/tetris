defmodule TetrisOtp.Supervisors.Room do
  @moduledoc """
  Dynamic Supervisor that starts Room servers

  @supervisor: Application
  @supervises: TetrisOtp.Servers.Room
  """

  use Supervisor

  @key __MODULE__
  @supervises TetrisOtp.Servers.Room

  def start_link([]) do
    IO.puts("Starting #{@key}")
    Supervisor.start_link(@key, :ok, name: @key)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def start_room(room) do
    Supervisor.start_child(@key, {@supervises, room})
  end

  def children do
    @key
    |> Supervisor.which_children()
    |> Enum.map(fn {room, _, _, _} -> room end)
  end
end

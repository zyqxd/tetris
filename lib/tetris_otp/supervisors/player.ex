defmodule TetrisOtp.Supervisors.Player do
  @moduledoc """
  Dynamic Supervisor that starts Player servers

  @supervisor: Application
  @supervises: TetrisOtp.Servers.Player
  """

  use Supervisor

  @key __MODULE__
  @supervises TetrisOtp.Servers.Player

  def start_link([]) do
    IO.puts("Starting #{@key}")
    Supervisor.start_link(@key, :ok, name: @key)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def start_player(name) do
    Supervisor.start_child(@key, {@supervises, name})
  end

  def children do
    @key
    |> Supervisor.which_children()
    |> Enum.map(fn {player, _, _, _} -> player end)
  end
end

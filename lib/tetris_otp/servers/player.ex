defmodule TetrisOtp.Servers.Player do
  @moduledoc """
  GenServer Player process

  @supervisor: TetrisOtp.Supervisors.Player
  """

  use GenServer

  @ptype :n
  @scope :l
  @key __MODULE__

  def lookup(player) do
    player |> term() |> Utils.Gproc.lookup()
  end

  def child_spec(player) do
    %{
      id: player,
      start: {@key, :start_link, [player]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link(player) do
    IO.puts("Starting #{@key}: #{player}")
    GenServer.start_link(@key, :ok, name: {:via, :gproc, term(player)})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  defp term(player) do
    {@ptype, @scope, {@key, player}}
  end
end

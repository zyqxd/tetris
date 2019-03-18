defmodule TetrisOtp.Servers.Player do
  @moduledoc """
  GenServer Player process

  @supervisor: TetrisOtp.Supervisors.Player
  """

  use GenServer
  require Logger

  @ptype :n
  @scope :l
  @key __MODULE__

  def lookup(args) do
    args |> term() |> Utils.Gproc.lookup()
  end

  def child_spec({player, room}) do
    %{
      id: {player, room},
      start: {@key, :start_link, [{player, room}]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link({player, room}) do
    Logger.info("Starting #{@key}: #{player}")
    GenServer.start_link(@key, :ok, name: {:via, :gproc, term({player, room})})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  defp term({player, room}) do
    {@ptype, @scope, {@key, {player, room}}}
  end
end

defmodule TetrisOtp.Supervisors.Room do
  @moduledoc """
  Dynamic Supervisor that starts Room servers

  @supervisor: TetrisOtp.Supervisors.Lobby
  @supervises: [
    TetrisOtp.Servers.Room,
    TetrisOtp.Supervisor.RoomPlayer
  ]
  """

  use Supervisor
  require Logger

  @ptype :n
  @scope :l
  @key __MODULE__

  def lookup(room) do
    room |> term() |> Utils.Gproc.lookup()
  end

  def child_spec({room, max_players}) do
    %{
      id: {@key, room},
      start: {@key, :start_link, [{room, max_players}]},
      restart: :temporary,
      type: :supervisor
    }
  end

  def start_link({room, _} = args) do
    Logger.info("Starting #{@key}: #{room}")
    Supervisor.start_link(@key, args, name: {:via, :gproc, term(room)})
  end

  def init({room, max_players}) do
    children = [
      {TetrisOtp.Supervisors.RoomPlayer, room},
      {TetrisOtp.Servers.Match, {room, max_players}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp term(room) do
    {@ptype, @scope, {@key, room}}
  end
end

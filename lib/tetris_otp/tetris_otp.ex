defmodule TetrisOtp do
  @moduledoc false

  def lookup_match(match) do
    TetrisOtp.Servers.Match.lookup(match)
  end

  def players_in_room(room) do
    room
    |> TetrisOtp.Supervisors.RoomPlayer.children()
    |> Enum.map(fn {{player, _}, _, _, _} -> player end)
  end

  def rooms do
    TetrisOtp.Supervisors.Lobby.children()
    |> Enum.map(fn {{_, room}, _, _, _} -> room end)
  end

  def start_room(room) do
    TetrisOtp.Supervisors.Lobby.start_room(room)
  end

  def start_room(room, max_players) when max_players <= 100 do
    TetrisOtp.Supervisors.Lobby.start_room(room, max_players)
  end

  def add_player_into(match, player) do
    TetrisOtp.Servers.Match.add_player_into(match, player)
  end
end

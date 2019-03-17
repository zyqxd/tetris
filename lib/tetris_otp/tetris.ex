defmodule TetrisOtp do
  @moduledoc false

  def add_player_into(room, player) do
    TetrisOtp.Servers.Room.add_player_into(room, player)
  end

  def lookup_player(player) do
    TetrisOtp.Servers.Player.lookup(player)
  end

  def lookup_room(room) do
    TetrisOtp.Servers.Room.lookup(room)
  end

  def players_in(room) do
    TetrisOtp.Servers.Room.players_in(room)
  end

  def rooms do
    TetrisOtp.Supervisors.Room.children()
  end

  def players do
    TetrisOtp.Supervisors.Player.children()
  end

  def start_room(room) do
    TetrisOtp.Supervisors.Room.start_room(room)
  end
end

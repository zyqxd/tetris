defmodule TetrisOtpTest do
  use ExUnit.Case, async: false
  @moduletag capture_log: true

  describe "tetris otp" do
    @room "a room"
    @player "a dude"

    setup do
      Application.stop(:tetris)
      :ok = Application.start(:tetris)
      {:ok, room} = Tetris.start_room(@room)

      %{room: room}
    end

    test "room will monitor players" do
      Tetris.add_player_into(@room, @player)

      assert [@player] = Tetris.players_in(@room)
    end

    test "room will not terminate when player crashes" do
      {:ok, player} = Tetris.add_player_into(@room, @player)

      catch_exit(GenServer.call(player, :a_really_bad_key))

      assert [@room] = Tetris.rooms()
    end

    test "room termination will terminate players", %{room: room} do
      Tetris.add_player_into(@room, @player)
      catch_exit(GenServer.call(room, :a_really_bad_key))

      assert [] = Tetris.rooms()
      assert [] = Tetris.players()
    end
  end
end

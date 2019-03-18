defmodule TetrisOtpTest do
  use ExUnit.Case, async: false
  @moduletag capture_log: true
  @room "a room"
  @player "a dude"

  setup do
    Application.stop(:tetris)
    :ok = Application.start(:tetris)
  end

  describe "unit" do
    test "lookup_match/1" do
      assert {:ok, _} = TetrisOtp.start_room(@room)
      assert {:ok, _} = TetrisOtp.lookup_match(@room)
    end

    test "players_in_room/1" do
      assert {:ok, _} = TetrisOtp.start_room(@room)
      assert {:ok, _} = TetrisOtp.add_player_into(@room, @player)
      assert [@player] = TetrisOtp.players_in_room(@room)
    end

    test "rooms/0" do
      assert [] = TetrisOtp.rooms()
      assert {:ok, _} = TetrisOtp.start_room(@room)
      assert [@room] = TetrisOtp.rooms()
    end

    test "start_room/1" do
      assert {:ok, _pid} = TetrisOtp.start_room(@room)
    end

    test "start_room/2" do
      assert {:ok, _pid} = TetrisOtp.start_room(@room, 10)
    end

    test "add_player_into/2" do
      assert {:ok, _} = TetrisOtp.start_room(@room)
      assert {:ok, _} = TetrisOtp.add_player_into(@room, @player)
    end
  end

  describe "feature" do
    setup do
      {:ok, room} = TetrisOtp.start_room(@room)

      %{room: room}
    end

    test "room will monitor players" do
      TetrisOtp.add_player_into(@room, @player)

      assert [@player] = TetrisOtp.players_in_room(@room)
    end

    test "room will not terminate when player crashes" do
      {:ok, player} = TetrisOtp.add_player_into(@room, @player)

      catch_exit(GenServer.call(player, :a_really_bad_key))

      assert [@room] = TetrisOtp.rooms()
      assert [] = TetrisOtp.players_in_room(@room)
    end

    test "room termination will terminate players", %{room: room} do
      TetrisOtp.add_player_into(@room, @player)
      catch_exit(GenServer.call(room, :a_really_bad_key))

      assert [] = TetrisOtp.rooms()
    end

    test "room cannot have two players of the same name" do
      assert {:ok, pid} = TetrisOtp.add_player_into(@room, @player)

      assert {:error, {:already_started, ^pid}} =
               TetrisOtp.add_player_into(@room, @player)
    end

    test "room cannot have more than max players (default 100)" do
      room = "small room"
      TetrisOtp.start_room(room, 10)
      Enum.each(1..10, fn i -> TetrisOtp.add_player_into(room, i) end)

      assert {:error, :match_full} = TetrisOtp.add_player_into(room, @player)
    end
  end
end

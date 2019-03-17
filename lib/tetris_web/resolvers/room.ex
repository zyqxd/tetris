defmodule TetrisWeb.Resolvers.Room do
  @moduledoc false
  alias Absinthe.Relay.Connection

  def resolve(pagination_args, _ctx) do
    {:ok, Connection.from_list([], pagination_args)}
  end

  def join_room(_a, _b, _ctx) do
    {:ok, nil}
  end

  def create_room(_a, _b, _ctx) do
    {:ok, nil}
  end
end

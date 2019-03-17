defmodule TetrisWeb.Resolvers.Player do
  @moduledoc false
  alias Absinthe.Relay.Connection

  def resolve(pagination_args, _ctx) do
    {:ok, Connection.from_list([], pagination_args)}
  end

  def resolve(%{name: _name}, pagination_args, _ctx) do
    {:ok, Connection.from_list([], pagination_args)}
  end

  def do_action(_a, _b, _ctx) do
    {:ok, nil}
  end
end

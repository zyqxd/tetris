defmodule TetrisWeb.Schema do
  @moduledoc """
  Main GraphQL schema

  Avoid defining any types in here. Instead, create a module with your
  types and import them here.
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types TetrisWeb.Types.Player
  import_types TetrisWeb.Types.Room

  node interface do
    resolve_type &TetrisWeb.Resolvers.Node.resolve/2
  end

  query do
    connection field(:players, node_type: :player) do
      description "Root query field for players"

      resolve &TetrisWeb.Resolvers.Player.resolve/2
    end

    connection field(:rooms, node_type: :room) do
      description "Root query field for rooms"

      resolve &TetrisWeb.Resolvers.Room.resolve/2
    end
  end
end

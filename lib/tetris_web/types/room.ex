defmodule TetrisWeb.Types.Room do
  @moduledoc """
  Room type definition
  """

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection node_type: :room

  node object :room do
    description "A room, has many players"

    field :name, non_null(:string)

    connection field :players, node_type: :player do
      description "A connection of players in this chat"

      resolve &TetrisWeb.Resolvers.Player.resolve/3
    end
  end

  object :room_mutations do
    payload field :join_room do
      input do
        field :room, non_null(:string)
        field :player, non_null(:string)
      end

      resolve &TetrisWeb.Resolvers.Room.join_room/3
    end

    payload field :create_room do
      input do: field(:room, non_null(:string))

      resolve &TetrisWeb.Resolvers.Room.create_room/3
    end
  end
end

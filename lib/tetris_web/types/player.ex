defmodule TetrisWeb.Types.Player do
  @moduledoc """
  Player type definition
  """
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  connection(node_type: :player)

  node object(:player) do
    description("A player, belongs to a room")

    field(:name, non_null(:string))
  end

  object :player_mutations do
    payload field(:do_action) do
      input(do: field(:action, non_null(:string)))

      resolve(&TetrisWeb.Resolvers.Player.do_action/3)
    end
  end
end

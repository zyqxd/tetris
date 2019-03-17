defmodule TetrisWeb.Resolvers.Node do
  @moduledoc """
  Node resolver module

  Implements resolve/2 function for all node types. All new nodes must be added
  in here
  """
  def resolve(_, _), do: :room
end

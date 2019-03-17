defmodule TetrisWeb.Router do
  use Phoenix.Router

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: TetrisWeb.Schema,
    interface: :advanced,
    json_codec: Jason

  forward "/", Absinthe.Plug,
    schema: TetrisWeb.Schema,
    json_codec: Jason
end

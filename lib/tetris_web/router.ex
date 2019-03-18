defmodule TetrisWeb.Router do
  use Phoenix.Router

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: TetrisWeb.Schema,
    interface: :advanced,
    json_codec: Jason

  forward "/api", Absinthe.Plug,
    schema: TetrisWeb.Schema,
    json_codec: Jason

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  forward "/", TetrisWeb.MainController, :index
end

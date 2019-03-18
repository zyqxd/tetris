defmodule TetrisWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tetris

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Static,
    at: "/",
    from: :tetris,
    gzip: false

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.Session,
    store: :cookie,
    key: "_tetris_key",
    signing_salt: "2TJZiJl3"

  plug TetrisWeb.Router
end

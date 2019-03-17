defmodule TetrisWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :tetris

  plug Plug.RequestId
  plug Plug.Logger

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug TetrisWeb.Router
end

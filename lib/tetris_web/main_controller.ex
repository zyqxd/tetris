defmodule TetrisWeb.MainController do
  use TetrisWeb, :controller

  def index(conn, _params) do
    send_file(conn, 200, "./priv/static/app.html")
  end
end

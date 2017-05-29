defmodule ExChess.Web.PageController do
  use ExChess.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

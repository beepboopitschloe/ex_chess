defmodule ExChess.Web.Router do
  use ExChess.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExChess.Web do
    pipe_through :api

    get "/user/:user", UserController, :show
    resources "/game", GameController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExChess.Web do
  #   pipe_through :api
  # end
end

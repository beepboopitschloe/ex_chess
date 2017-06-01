defmodule ExChess.Web.Router do
  use ExChess.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
  end

  scope "/api", ExChess.Web do
    pipe_through :api

    get "/user/:id", UserController, :show
    get "/identity", UserController, :identity

    post "/auth/signup", AuthController, :signup
    post "/auth/login", AuthController, :login

    get "/game", GameController, :index
    get "/game/:id", GameController, :show
    post "/game", GameController, :create
  end
end

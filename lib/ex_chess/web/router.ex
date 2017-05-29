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

    resources "/game", GameController, except: [:new, :edit]
  end
end

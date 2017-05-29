defmodule ExChess.Web.AuthView do
  use ExChess.Web, :view
  alias ExChess.Web.UserView

  def render("login.json", %{user: user, jwt: jwt}) do
    %{data: %{identity: render_one(user, UserView, "user.json"),
	      jwt: jwt}}
  end

  def render("error.json", %{message: msg}) do
    %{error: msg}
  end
end

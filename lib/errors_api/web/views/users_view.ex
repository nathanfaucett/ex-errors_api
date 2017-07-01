defmodule ErrorsApi.Web.UsersView do

  use ErrorsApi.Web, :view

  def render("show.json", %{ user: user, roles: roles }) do
    %{ id: user.id,
       email: user.email,
       username: user.username,
       completed: user.completed,
       roles: roles }
  end

  def render("show.json", %{ user: user }) do
    %{ id: user.id,
       email: user.email,
       username: user.username,
       completed: user.completed }
  end

end

defmodule ErrorsApi.Web.UsersView do

  use ErrorsApi.Web, :view

  def render("show.json", %{ user: user }) do
    %{ id: user.id,
       email: user.email,
       username: user.username }
  end

end

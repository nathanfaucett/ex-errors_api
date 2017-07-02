defmodule ErrorsApi.Web.UsersController do

  use ErrorsApi.Web, :controller


  def get_current_user(conn, _params) do
    current_user = conn.assigns[:current_user]
    render(conn, "show.json", user: current_user)
  end

end

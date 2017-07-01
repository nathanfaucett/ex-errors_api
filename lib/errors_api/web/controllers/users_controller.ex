defmodule ErrorsApi.Web.UsersController do

  use ErrorsApi.Web, :controller

  alias ErrorsApi.Repo
  alias ErrorsApi.Accounts.UserRole
  alias ErrorsApi.Accounts.Role
  alias ErrorsApi.Accounts

  import Ecto.Query


  def get_current_user(conn, _params) do
    current_user = conn.assigns[:current_user]
    roles_query = from(ur in UserRole,
                       join: r in Role,
                       where: ur.user_id == ^current_user.id and r.id == ur.role_id,
                       select: r.name)
    roles = Repo.all(roles_query)

    render(conn, "show.json", user: current_user, roles: roles )
  end

  def complete_registration(conn, params) do
    current_user = conn.assigns[:current_user]

    user = Accounts.complete_registration(current_user, params)

    render(conn, "show.json", user: user)
  end

end

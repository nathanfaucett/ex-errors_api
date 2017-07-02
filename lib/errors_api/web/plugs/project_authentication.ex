defmodule ErrorsApi.Web.Plugs.ProjectAuthentication do
  use Phoenix.Controller

  alias ErrorsApi.Projects
  alias ErrorsApi.Utils.Config

  import ErrorsApi.Web.Plugs.Helpers, only: [halt_execution: 3]

  def init(default), do: default

  def call(conn, _default) do

    # get access_token from the headers
    access_token = Plug.Conn.get_req_header(conn, Config.app_get(:api_project_token_header))
                 |> List.first()

    # if access_token has not been set
    if is_nil(access_token) do

      halt_execution(conn, :unauthorized, "401.json")

    else

      # attempt to get project from session
      current_user = conn.assigns[:current_user]
      project = Projects.get_project_by_user_and_token(current_user.id, access_token)

      if project do
        assign(conn, :current_project, project)
      else
        halt_execution(conn, :unauthorized, "401.json")
      end

    end
  end

end

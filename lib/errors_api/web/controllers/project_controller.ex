defmodule ErrorsApi.Web.ProjectController do
  use ErrorsApi.Web, :controller

  alias ErrorsApi.Projects
  alias ErrorsApi.Projects.Project

  action_fallback ErrorsApi.Web.FallbackController

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    projects = Projects.list_projects(current_user.id)
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    current_user = conn.assigns[:current_user]
    project_params = Map.put(project_params, "user_id", current_user.id)

    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_path(conn, :show, project))
      |> render("show.json", project: project)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    project = Projects.get_project!(current_user.id, id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    current_user = conn.assigns[:current_user]
    project = Projects.get_project!(current_user.id, id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  def regenerate_token(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    project = Projects.get_project!(current_user.id, id)

    with {:ok, %Project{} = project} <- Projects.regenerate_project_token(project) do
      render(conn, "show.json", project: project)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    project = Projects.get_project!(current_user.id, id)
    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end

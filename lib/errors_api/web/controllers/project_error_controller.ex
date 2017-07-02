defmodule ErrorsApi.Web.ProjectErrorController do
  use ErrorsApi.Web, :controller

  alias ErrorsApi.Projects
  alias ErrorsApi.Projects.ProjectError

  action_fallback ErrorsApi.Web.FallbackController

  def index(conn, %{"project_id" => project_id}) do
    errors = Projects.list_errors(project_id)
    render(conn, "index.json", errors: errors)
  end

  def create(conn, %{"project_id" => project_id, "project_error" => project_error_params}) do
    project_error_params = Map.put(project_error_params, "project_id", project_id)
    with {:ok, %ProjectError{} = project_error} <- Projects.create_project_error(project_error_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_project_error_path(conn, :show, project_id, project_error))
      |> render("show.json", project_error: project_error)
    end
  end

  def show(conn, %{"project_id" => project_id, "id" => id}) do
    project_error = Projects.get_project_error!(project_id, id)
    render(conn, "show.json", project_error: project_error)
  end

  def update(conn, %{"project_id" => project_id, "id" => id, "project_error" => project_error_params}) do
    project_error = Projects.get_project_error!(project_id, id)

    with {:ok, %ProjectError{} = project_error} <- Projects.update_project_error(project_error, project_error_params) do
      render(conn, "show.json", project_error: project_error)
    end
  end

  def delete(conn, %{"project_id" => project_id, "id" => id}) do
    project_error = Projects.get_project_error!(project_id, id)
    with {:ok, %ProjectError{}} <- Projects.delete_project_error(project_error) do
      send_resp(conn, :no_content, "")
    end
  end
end

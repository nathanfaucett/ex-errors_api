defmodule ErrorsApi.Web.ProjectErrorControllerTest do
  use ErrorsApi.Web.ConnCase

  alias ErrorsApi.Utils.Config
  alias ErrorsApi.Accounts

  alias ErrorsApi.Projects
  alias ErrorsApi.Projects.ProjectError

  @create_user_attrs %{email: "example@domain.com"}
  @create_project_attrs %{name: "some name"}

  @create_attrs %{count: 42, stack_trace: "some stack_trace"}
  @update_attrs %{count: 43, stack_trace: "some updated stack_trace"}
  @invalid_attrs %{count: nil, stack_trace: nil}

  def fixture(project, :project_error) do
    {:ok, project_error} = Projects.create_project_error(
      Map.put(@create_attrs, :project_id, project.id))
    project_error
  end

  setup %{conn: conn} do
    user = Accounts.find_or_create_user!("github", @create_user_attrs)
    {:ok, project} = Projects.create_project(
      Map.put(@create_project_attrs, :user_id, user.id))
    {:ok,
      user: user,
      project: project,
      conn: conn
        |> put_req_header(Config.app_get(:api_user_token_header), user.token)
        |> put_req_header("accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn, project: project} do
    conn = get conn, project_project_error_path(conn, :index, project.id)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates project_error and renders project_error when data is valid", %{conn: conn, project: project} do
    conn = post conn, project_project_error_path(conn, :create, project.id), project_error: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    project_error = Projects.get_project_error!(project.id, id)
    assert project_error.id == id
    assert project_error.count == 42
    assert project_error.stack_trace == "some stack_trace"
  end

  test "does not create project_error and renders errors when data is invalid", %{conn: conn, project: project} do
    conn = post conn, project_project_error_path(conn, :create, project.id), project_error: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen project_error and renders project_error when data is valid", %{conn: conn, project: project} do
    %ProjectError{id: id} = project_error = fixture(project, :project_error)
    conn = put conn, project_project_error_path(conn, :update, project.id, project_error), project_error: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    project_error = Projects.get_project_error!(project.id, id)
    assert project_error.id == id
    assert project_error.count == 43
    assert project_error.stack_trace == "some updated stack_trace"
  end

  test "does not update chosen project_error and renders errors when data is invalid", %{conn: conn, project: project} do
    project_error = fixture(project, :project_error)
    conn = put conn, project_project_error_path(conn, :update, project.id, project_error), project_error: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen project_error", %{conn: conn, project: project} do
    project_error = fixture(project, :project_error)
    conn = delete conn, project_project_error_path(conn, :delete, project.id, project_error)
    assert response(conn, 204)
    assert_raise Ecto.NoResultsError, fn -> Projects.get_project_error!(project.id, project_error.id) end
  end
end

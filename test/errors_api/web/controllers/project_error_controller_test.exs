defmodule ErrorsApi.Web.ProjectErrorControllerTest do
  use ErrorsApi.Web.ConnCase

  alias ErrorsApi.Utils.Config
  alias ErrorsApi.Accounts

  alias ErrorsApi.Projects

  @create_user_attrs %{email: "example@domain.com"}
  @create_project_attrs %{name: "some name", error_callback: "http://localhost:9999/errors"}

  @create_attrs %{name: "some name", stack_trace: "some stack_trace", meta: "some meta"}
  @invalid_attrs %{name: nil, stack_trace: nil, meta: nil}

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
        |> put_req_header(Config.app_get(:api_project_token_header), project.token)
        |> put_req_header("accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn, project: project} do
    conn = get conn, project_project_error_path(conn, :index, project.id)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates project_error and renders project_error when data is valid", %{conn: conn, project: project} do
    conn = post conn, project_error_path(conn, :create), project_error: @create_attrs
    json_project_error = json_response(conn, 201)["data"];
    id = json_project_error["id"];
    meta_id = Enum.at(json_project_error["meta"], 0)["id"];

    assert json_project_error == %{
      "id" => id,
      "project_id" => project.id,
      "stack_trace" => "some stack_trace",
      "meta" => [%{
        "count" => 1,
        "data" => "some meta",
        "id" => meta_id,
        "project_error_id" => id}] }

    project_error = Projects.get_project_error!(project.id, id)
    assert project_error.id == id
    assert project_error.stack_trace == "some stack_trace"
  end

  test "does not create project_error and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_error_path(conn, :create), project_error: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen project_error", %{conn: conn, project: project} do
    project_error = fixture(project, :project_error)
    conn = delete conn, project_project_error_path(conn, :delete, project.id, project_error)
    assert response(conn, 204)
    assert_raise Ecto.NoResultsError, fn -> Projects.get_project_error!(project.id, project_error.id) end
  end
end

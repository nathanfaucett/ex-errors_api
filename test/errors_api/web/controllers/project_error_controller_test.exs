defmodule ErrorsApi.Web.ProjectErrorControllerTest do
  use ErrorsApi.Web.ConnCase

  alias ErrorsApi.Utils.Config
  alias ErrorsApi.Accounts

  alias ErrorsApi.Projects

  @create_user_attrs %{email: "example@domain.com"}
  @create_project_attrs %{name: "some name", error_callback: "http://localhost:9999/errors"}

  @create_attrs %{
    name: "some name",
    count: 1,
    occurred_at: DateTime.utc_now,
    stack_trace: "some stack_trace",
    meta: %{"env" => "chrome"}}
  @invalid_attrs %{name: nil, occurred_at: nil, stack_trace: nil, meta: nil}

  def fixture(project, :project_error, attrs \\ %{}) do
    {:ok, project_error} = Projects.create_project_error(
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put(:project_id, project.id))
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
        |> put_req_header("accept-language", "en")
        |> put_req_header("accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn, project: project} do
    conn = get conn, project_project_error_path(conn, :index, project.id)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates project_error and renders project_error when data is valid", %{conn: conn, project: project} do
    attrs = @create_attrs
    conn = post conn, project_error_path(conn, :create), project_error: attrs
    json_project_error = json_response(conn, 201)["data"];
    id = json_project_error["id"];
    meta_id = Enum.at(json_project_error["meta"], 0)["id"];

    assert json_project_error == %{
      "id" => id,
      "project_id" => project.id,
      "occurred_at" => Poison.decode!(Poison.encode!(attrs.occurred_at)),
      "count" => 1,
      "stack_trace" => "some stack_trace",
      "meta" => [%{
        "count" => 1,
        "data" => %{"env" => "chrome"},
        "occurred_at" => Poison.decode!(Poison.encode!(attrs.occurred_at)),
        "id" => meta_id,
        "project_error_id" => id}] }

    project_error = Projects.get_project_error!(project.id, id)
    assert project_error.id == id
    assert project_error.stack_trace == "some stack_trace"
  end

  test "creates project_error and currectly inserts and incs meta and counters", %{conn: conn, project: project} do
    chrome_error_datetime = DateTime.utc_now
    post conn, project_error_path(conn, :create), project_error:
      Enum.into(%{occurred_at: chrome_error_datetime}, @create_attrs)

    post conn, project_error_path(conn, :create), project_error:
      Enum.into(%{occurred_at: DateTime.utc_now}, @create_attrs)

    ie_error_datetime = DateTime.utc_now
    post conn, project_error_path(conn, :create), project_error:
      Enum.into(%{occurred_at: ie_error_datetime, meta: %{"env" => "ie"}}, @create_attrs)

    post conn, project_error_path(conn, :create), project_error:
      Enum.into(%{occurred_at: DateTime.utc_now, meta: %{"env" => "ie"}}, @create_attrs)

    conn = post conn, project_error_path(conn, :create), project_error:
      Enum.into(%{occurred_at: DateTime.utc_now}, @create_attrs)

    json_project_error = json_response(conn, 201)["data"];

    assert %{
      "id" => json_project_error["id"],
      "project_id" => json_project_error["project_id"],
      "occurred_at" => json_project_error["occurred_at"],
      "count" => json_project_error["count"],
      "stack_trace" => json_project_error["stack_trace"]}
      == %{
      "id" => json_project_error["id"],
      "project_id" => project.id,
      "occurred_at" => Poison.decode!(Poison.encode!(chrome_error_datetime)),
      "count" => 5,
      "stack_trace" => "some stack_trace"}

    assert Enum.at(json_project_error["meta"], 0) == %{
          "id" => Enum.at(json_project_error["meta"], 0)["id"],
          "project_error_id" => json_project_error["id"],
          "count" => 2,
          "data" => %{"env" => "ie"},
          "occurred_at" => Poison.decode!(Poison.encode!(ie_error_datetime)) }

    assert Enum.at(json_project_error["meta"], 1) == %{
          "id" => Enum.at(json_project_error["meta"], 1)["id"],
          "project_error_id" => json_project_error["id"],
          "count" => 3,
          "data" => %{"env" => "chrome"},
          "occurred_at" => Poison.decode!(Poison.encode!(chrome_error_datetime)) }
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

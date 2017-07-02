defmodule ErrorsApi.Web.ProjectControllerTest do
  use ErrorsApi.Web.ConnCase

  alias ErrorsApi.Utils.Config
  alias ErrorsApi.Accounts

  alias ErrorsApi.Projects
  alias ErrorsApi.Projects.Project

  @create_user_attrs %{email: "example@domain.com"}
  
  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:project, user) do
    attrs = Map.put(@create_attrs, :user_id, user.id)
    {:ok, project} = Projects.create_project(attrs)
    project
  end

  setup %{conn: conn} do
    user = Accounts.find_or_create_user!("github", @create_user_attrs)
    {:ok,
      user: user,
      conn: conn
        |> put_req_header(Config.app_get(:api_user_token_header), user.token)
        |> put_req_header("accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates project and renders project when data is valid", %{conn: conn, user: user} do
    conn = post conn, project_path(conn, :create), project: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    project = Projects.get_project!(user.id, id)
    assert project.id == id
    assert project.user_id == user.id
    assert project.name == "some name"
    assert String.length(project.token) == 44
  end

  test "gets and renders project when data is valid", %{conn: conn, user: user} do
    %Project{id: id, token: token} = fixture(:project, user)
    conn = get conn, project_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "name" => "some name",
      "token" => token,
      "user_id" => user.id}
  end

  test "does not create project and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen project and renders project when data is valid", %{conn: conn, user: user} do
    %Project{id: id} = project = fixture(:project, user)
    conn = put conn, project_path(conn, :update, project), project: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    project = Projects.get_project!(user.id, id)
    assert project.id == id
    assert project.user_id == user.id
    assert project.name == "some updated name"
  end

  test "does not update chosen project and renders errors when data is invalid", %{conn: conn, user: user} do
    project = fixture(:project, user)
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen project", %{conn: conn, user: user} do
    project = fixture(:project, user)
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    assert_raise Ecto.NoResultsError, fn ->
      Projects.get_project!(user.id, project.id)
    end
  end
end

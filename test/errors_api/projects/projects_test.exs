defmodule ErrorsApi.ProjectsTest do
  use ErrorsApi.DataCase

  alias ErrorsApi.Projects
  alias ErrorsApi.Accounts

  @create_user_attrs %{email: "example@domain.com"}
  @create_project_attrs %{name: "some name"}


  def user_fixture(attrs \\ %{}) do
    Accounts.find_or_create_user!("github", Enum.into(attrs, @create_user_attrs))
  end

  def project_fixture(user, attrs \\ %{}) do
    attrs = Map.put(attrs, :user_id, user.id)
    {:ok, project} =
      attrs
      |> Enum.into(@create_project_attrs)
      |> Projects.create_project()

    project
  end


  describe "projects" do
    alias ErrorsApi.Projects.Project

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    setup do
      {:ok, user: user_fixture()}
    end

    test "list_projects/1 returns all projects", %{user: user} do
      project = project_fixture(user)
      assert Projects.list_projects(user.id) == [project]
    end

    test "get_project/2 returns the project with given id", %{user: user} do
      project = project_fixture(user)
      assert Projects.get_project!(user.id, project.id) == project
    end

    test "create_project/1 with valid data creates a project", %{user: user} do
      assert {:ok, %Project{} = project} = Projects.create_project(
        Map.put(@create_project_attrs, :user_id, user.id))
      assert project.name == "some name"
      assert String.length(project.token) == 44
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project", %{user: user} do
      project = project_fixture(user)
      assert {:ok, project} = Projects.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset", %{user: user} do
      project = project_fixture(user)
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(user.id, project.id)
    end

    test "regenerate_project_token/1", %{user: user} do
      %Project{token: token} = project = project_fixture(user)
      assert {:ok, new_project} = Projects.regenerate_project_token(project)
      assert new_project.token != token
    end

    test "delete_project/1 deletes the project", %{user: user} do
      project = project_fixture(user)
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn ->
        Projects.get_project!(user.id, project.id)
      end
    end

    test "change_project/1 returns a project changeset", %{user: user} do
      project = project_fixture(user)
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end

  describe "errors" do
    alias ErrorsApi.Projects.ProjectError

    @valid_attrs %{stack_trace: "some stack_trace"}
    @update_attrs %{stack_trace: "some updated stack_trace"}
    @invalid_attrs %{stack_trace: nil}

    setup do
      user = user_fixture()
      project = project_fixture(user)
      {:ok, user: user, project: project}
    end

    def project_error_fixture(project, attrs \\ %{}) do
      {:ok, project_error} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:project_id, project.id)
        |> Projects.create_project_error()

      project_error
    end

    test "list_errors/0 returns all errors", %{project: project} do
      project_error = project_error_fixture(project)
        |> Repo.preload(:meta)
      assert Projects.list_errors(project.id) == [project_error]
    end

    test "get_project_error!/1 returns the project_error with given id", %{project: project} do
      project_error = project_error_fixture(project)
        |> Repo.preload(:meta)
      assert Projects.get_project_error!(project.id, project_error.id) == project_error
    end

    test "create_project_error/1 with valid data creates a project_error", %{project: project} do
      assert {:ok, %ProjectError{} = project_error} = Projects.create_project_error(
        Map.put(@valid_attrs, :project_id, project.id))
      assert project_error.stack_trace == "some stack_trace"
    end

    test "create_project_error/1 with invalid data returns error changeset", %{} do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project_error(@invalid_attrs)
    end

    test "update_project_error/2 with valid data updates the project_error", %{project: project} do
      project_error = project_error_fixture(project)
      assert {:ok, project_error} = Projects.update_project_error(project_error, @update_attrs)
      assert %ProjectError{} = project_error
      assert project_error.stack_trace == "some updated stack_trace"
    end

    test "update_project_error/2 with invalid data returns error changeset", %{project: project} do
      project_error = project_error_fixture(project)
        |> Repo.preload(:meta)
      assert {:error, %Ecto.Changeset{}} = Projects.update_project_error(project_error, @invalid_attrs)
      assert project_error == Projects.get_project_error!(project.id, project_error.id)
    end

    test "delete_project_error/1 deletes the project_error", %{project: project} do
      project_error = project_error_fixture(project)
      assert {:ok, %ProjectError{}} = Projects.delete_project_error(project_error)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project_error!(project.id, project_error.id) end
    end

    test "change_project_error/1 returns a project_error changeset", %{project: project} do
      project_error = project_error_fixture(project)
      assert %Ecto.Changeset{} = Projects.change_project_error(project_error)
    end
  end
end

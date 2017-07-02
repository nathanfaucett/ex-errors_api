defmodule ErrorsApi.ProjectsTest do
  use ErrorsApi.DataCase

  alias ErrorsApi.Projects
  alias ErrorsApi.Accounts

  describe "projects" do
    alias ErrorsApi.Projects.Project

    @create_user_attrs %{email: "example@domain.com"}
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def project_fixture(user, attrs \\ %{}) do
      attrs = Map.put(attrs, :user_id, user.id)
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_project()

      project
    end

    setup do
      user = Accounts.find_or_create_user!("github", @create_user_attrs)
      {:ok, user: user}
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
        Map.put(@valid_attrs, :user_id, user.id))
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
end

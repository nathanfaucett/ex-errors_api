defmodule ErrorsApi.Projects do
  @moduledoc """
  The boundary for the Projects system.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias ErrorsApi.Repo
  alias ErrorsApi.Utils.Crypto

  alias ErrorsApi.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects(user_id)
      [%Project{}, ...]

  """
  def list_projects(user_id) do
    query = from p in Project,
      where: p.user_id == ^user_id,
      select: p

    Repo.all(query)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(1, 123)
      %Project{}

      iex> get_project!(1, 456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(user_id, id) do
    Repo.get_by!(Project, user_id: user_id, id: id)
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> put_change(:token, Crypto.secure_random(64))
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  regenerates a project token.

  ## Examples

      iex> regenerate_project_token(project)
      {:ok, %Project{}}

      iex> regenerate_project_token(project)
      {:error, %Ecto.Changeset{}}

  """
  def regenerate_project_token(%Project{} = project) do
    project
    |> change_project
    |> put_change(:token, Crypto.secure_random(64))
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end
end

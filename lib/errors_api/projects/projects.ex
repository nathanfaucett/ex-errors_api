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
  def get_project!(user_id, id), do:
    Repo.get_by!(Project, user_id: user_id, id: id)

  def get_project_by_user_and_token(user_id, token), do:
    Repo.get_by!(Project, user_id: user_id, token: token)

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

  alias ErrorsApi.Projects.ProjectError

  @doc """
  Returns the list of errors.

  ## Examples

      iex> list_errors()
      [%ProjectError{}, ...]

  """
  def list_errors(project_id) do
    query = from p in ProjectError,
      where: p.project_id == ^project_id,
      select: p

    Repo.all(query)
      |> Repo.preload(:meta)
  end

  @doc """
  Gets a single project_error.

  Raises `Ecto.NoResultsError` if the Project error does not exist.

  ## Examples

      iex> get_project_error!(123)
      %ProjectError{}

      iex> get_project_error!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_error!(project_id, id), do:
    Repo.get_by!(ProjectError, project_id: project_id, id: id)
      |> Repo.preload(:meta)

  @doc """
  Get or creates a project_error.

  ## Examples

      iex> create_or_get_project_error_and_meta(project_id, %{field: value})
      {:ok, %ProjectError{}}

      iex> create_or_get_project_error_and_meta(project_id, %{field: bad_value})
      {:error, nil}

  """
  def create_or_get_project_error_and_meta(project_id, attrs \\ %{}) do
    case create_or_get_project_error(project_id, attrs) do
      {:ok, project_error} ->
        case create_or_inc_project_meta(project_error, attrs) do
          {:ok, _project_meta} ->
            {:ok, Repo.preload(project_error, :meta)}
          _ -> {:error, nil}
        end
    _ -> {:error, nil}
    end
  end

  @doc """
  Get or creates a project_error.

  ## Examples

      iex> get_or_create_project_error(%{field: value})
      {:ok, %ProjectError{}}

      iex> get_or_create_project_error(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_or_get_project_error(project_id, attrs \\ %{}) do
    name = Map.get(attrs, "name", Map.get(attrs, :name))
    stack_trace = Map.get(attrs, "stack_trace", Map.get(attrs, :stack_trace))

    if name != nil and stack_trace != nil do
      case Repo.get_by(ProjectError, project_id: project_id, name: name, stack_trace: stack_trace) do
        nil ->
          create_project_error(%{
            project_id: project_id,
            name: name,
            stack_trace: stack_trace
          })
        project_error ->
          project_error
      end
    else
      {:error, nil}
    end
  end

  @doc """
  Creates a project_error.

  ## Examples

      iex> create_project_error(%{field: value})
      {:ok, %ProjectError{}}

      iex> create_project_error(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_error(attrs \\ %{}) do
    %ProjectError{}
    |> ProjectError.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_error.

  ## Examples

      iex> update_project_error(project_error, %{field: new_value})
      {:ok, %ProjectError{}}

      iex> update_project_error(project_error, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_error(%ProjectError{} = project_error, attrs) do
    project_error
    |> ProjectError.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProjectError.

  ## Examples

      iex> delete_project_error(project_error)
      {:ok, %ProjectError{}}

      iex> delete_project_error(project_error)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_error(%ProjectError{} = project_error) do
    Repo.delete(project_error)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_error changes.

  ## Examples

      iex> change_project_error(project_error)
      %Ecto.Changeset{source: %ProjectError{}}

  """
  def change_project_error(%ProjectError{} = project_error) do
    ProjectError.changeset(project_error, %{})
  end

  alias ErrorsApi.Projects.ProjectMeta

  @doc """
  Returns the list of meta.

  ## Examples

      iex> list_project_meta(project_error_id)
      [%ProjectMeta{}, ...]

  """
  def list_project_meta(project_error_id) do
    query = from p in ProjectMeta,
      where: p.project_error_id == ^project_error_id,
      select: p

    Repo.all(query)
  end

  @doc """
  Gets a single project_meta.

  Raises `Ecto.NoResultsMeta` if the Project meta does not exist.

  ## Examples

      iex> get_project_meta!(1, 123)
      %ProjectMeta{}

      iex> get_project_meta!(2, 456)
      ** (Ecto.NoResultsMeta)

  """
  def get_project_meta!(project_error_id, id), do:
    Repo.get_by!(ProjectMeta, project_error_id: project_error_id, id: id)

  @doc """
  Get or creates a project_error.

  ## Examples

      iex> get_or_create_project_error(%{field: value})
      {:ok, %ProjectError{}}

      iex> get_or_create_project_error(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_or_inc_project_meta(%ProjectError{} = project_error, attrs \\ %{}) do
    meta = Map.get(attrs, "meta", Map.get(attrs, :meta))

    if meta != nil do
      value = case Repo.get_by(ProjectMeta, project_error_id: project_error.id, meta: meta) do
        nil -> create_project_meta(%{
          meta: meta,
          project_error_id: project_error.id
        })
        project_meta -> project_meta
      end

      case value do
        {:ok, project_meta} ->
          project_meta
          |> ProjectMeta.changeset(%{count: project_meta.count + 1})
          |> Repo.update()
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, nil}
    end
  end

  @doc """
  Creates a project_meta.

  ## Examples

      iex> create_project_meta(%{field: value})
      {:ok, %ProjectMeta{}}

      iex> create_project_meta(%{field: bad_value})
      {:meta, %Ecto.Changeset{}}

  """
  def create_project_meta(attrs \\ %{}) do
    %ProjectMeta{}
    |> ProjectMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_meta.

  ## Examples

      iex> update_project_meta(project_meta, %{field: new_value})
      {:ok, %ProjectMeta{}}

      iex> update_project_meta(project_meta, %{field: bad_value})
      {:meta, %Ecto.Changeset{}}

  """
  def update_project_meta(%ProjectMeta{} = project_meta, attrs) do
    project_meta
    |> ProjectMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProjectMeta.

  ## Examples

      iex> delete_project_meta(project_meta)
      {:ok, %ProjectMeta{}}

      iex> delete_project_meta(project_meta)
      {:meta, %Ecto.Changeset{}}

  """
  def delete_project_meta(%ProjectMeta{} = project_meta) do
    Repo.delete(project_meta)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_meta changes.

  ## Examples

      iex> change_project_meta(project_meta)
      %Ecto.Changeset{source: %ProjectMeta{}}

  """
  def change_project_meta(%ProjectMeta{} = project_meta) do
    ProjectMeta.changeset(project_meta, %{})
  end
end

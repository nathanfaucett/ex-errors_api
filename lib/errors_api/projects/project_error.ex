defmodule ErrorsApi.Projects.ProjectError do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Projects.ProjectError


  schema "projects_errors" do

    # REFERENCES
    belongs_to :project, ErrorsApi.Projects.Project

    # FIELDS
    field :count, :integer
    field :stack_trace, :string

    timestamps()
  end

  @doc false
  def changeset(%ProjectError{} = project_error, attrs) do
    project_error
    |> cast(attrs, [:count, :stack_trace, :project_id])
    |> foreign_key_constraint(:project_id)
    |> validate_required([:count, :stack_trace, :project_id])
  end
end

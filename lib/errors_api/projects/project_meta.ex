defmodule ErrorsApi.Projects.ProjectMeta do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Projects.ProjectMeta


  schema "projects_meta" do

    # REFERENCES
    belongs_to :project_error, ErrorsApi.Projects.ProjectError

    # FIELDS
    field :count, :integer
    field :occurred_at, :utc_datetime
    field :meta, :map

    timestamps()
  end

  @doc false
  def changeset(%ProjectMeta{} = project_meta, attrs) do
    project_meta
    |> cast(attrs, [:count, :occurred_at, :meta, :project_error_id])
    |> foreign_key_constraint(:project_error_id)
    |> validate_required([:count, :occurred_at, :meta, :project_error_id])
  end
end

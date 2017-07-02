defmodule ErrorsApi.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Projects.Project


  schema "projects_projects" do

    # REFERENCES
    belongs_to :user, ErrorsApi.Accounts.User

    # FIELDS
    field :name, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:name, :user_id])
  end
end

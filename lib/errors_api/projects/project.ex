defmodule ErrorsApi.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Projects.Project
  alias ErrorsApi.Utils.Validate


  schema "projects_projects" do

    # REFERENCES
    belongs_to :user, ErrorsApi.Accounts.User

    # FIELDS
    field :name, :string
    field :token, :string

    field :error_callback, :string
    field :new_error_callback, :string

    timestamps()
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :error_callback, :new_error_callback, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:name, :user_id])
    |> Validate.url(:error_callback)
    |> Validate.url(:new_error_callback)
  end
end

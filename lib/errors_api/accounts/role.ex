defmodule ErrorsApi.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Accounts.Role


  schema "accounts_roles" do

    # REFERENCES
    has_many :user_roles, ErrorsApi.Accounts.UserRole
    has_many :users, ErrorsApi.Accounts.User

    # FIELDS
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
  end
end

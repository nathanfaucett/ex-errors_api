defmodule ErrorsApi.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Accounts.UserRole


  schema "accounts_user_roles" do

    # REFERENCES
    belongs_to :user, ErrorsApi.Accounts.User
    belongs_to :role, ErrorsApi.Accounts.Role

    # FIELDS
    #field :user_id, :id
    #field :role_id, :id

    timestamps()
  end

  @doc false
  def changeset(%UserRole{} = user_role, attrs) do
    user_role
    |> cast(attrs, [:role_id, :user_id])
    |> validate_required([:role_id, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:role)
  end
end

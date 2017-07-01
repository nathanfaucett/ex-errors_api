defmodule ErrorsApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Accounts.User


  schema "accounts_users" do

    # REFERENCES
    has_many :accounts_oauth2, ErrorsApi.Accounts.OAuth2
    has_one  :accounts_user_info, ErrorsApi.Accounts.UserInfo
    has_many :user_roles, ErrorsApi.Accounts.UserRole

    # FIELDS
    field :email, :string
    field :username, :string
    field :token, :string
    field :completed, :boolean

    # TIMESTAMPS
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :token])
    |> validate_required([:email, :username, :token])
    |> unique_constraint(:email)
    |> unique_constraint(:token)
  end
end

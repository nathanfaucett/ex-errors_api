defmodule ErrorsApi.Accounts.OAuth2 do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Accounts.OAuth2


  schema "accounts_oauth2" do

    # REFERENCES
    belongs_to :user, ErrorsApi.Accounts.User

    # FIELDS
    field :data, :string
    field :email, :string
    field :provider, :string

    # TIMESTAMPS
    timestamps()
  end

  @doc false
  def changeset(%OAuth2{} = o_auth2, attrs) do
    o_auth2
    |> cast(attrs, [:provider, :email, :data])
    |> cast_assoc(:user, :required)
    |> validate_required([:provider, :email, :data])
  end
end

defmodule ErrorsApi.Accounts.UserInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias ErrorsApi.Accounts.UserInfo
  alias ErrorsApi.Utils.FormData


  schema "accounts_user_infos" do

    # REFERENCES
    belongs_to :user, ErrorsApi.Accounts.User

    # FIELDS
    field :date_of_birth, :naive_datetime
    field :learning_disability, :boolean, default: false
    field :learning_disability_text, :string
    field :native_language, :string
    field :terms_of_service, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%UserInfo{} = user_info, attrs) do
    user_info
    |> cast(attrs, [:user_id, :date_of_birth, :native_language, :terms_of_service, :learning_disability, :learning_disability_text])
    |> validate_required([:date_of_birth, :native_language, :terms_of_service, :user_id])
    |> validate_inclusion(:native_language, FormData.language_codes_validation_list())
    |> validate_acceptance(:terms_of_service)
    |> assoc_constraint(:user)
  end
end

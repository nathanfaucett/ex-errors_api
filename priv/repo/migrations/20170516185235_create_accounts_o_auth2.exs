defmodule NotesApi.Repo.Migrations.CreateNotesApi.Accounts.OAuth2 do
  use Ecto.Migration

  def change do
    create table(:accounts_oauth2) do
      add :provider, :string
      add :email, :string
      add :data, :text
      add :user_id, references(:accounts_users, on_delete: :nothing, null: false)

      timestamps()
    end

    create unique_index(:accounts_oauth2, [:email, :provider])

  end
end

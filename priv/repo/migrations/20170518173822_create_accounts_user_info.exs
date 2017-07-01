defmodule NotesApi.Repo.Migrations.CreateNotesApi.Account.UserInfo do
  use Ecto.Migration

  def change() do
    create table(:accounts_user_infos) do
      # REFERENCES
      add :user_id, references(:accounts_users, on_delete: :nothing, null: false)

      # FIELDS
      add :date_of_birth, :naive_datetime
      add :native_language, :string
      add :terms_of_service, :boolean, default: false, null: false
      add :learning_disability, :boolean, default: false, null: false
      add :learning_disability_text, :text

      # TIMESTAMPS
      timestamps()
    end

  end
end

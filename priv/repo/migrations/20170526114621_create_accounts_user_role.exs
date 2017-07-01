defmodule NotesApi.Repo.Migrations.CreateNotesApi.Accounts.UserRole do
  use Ecto.Migration

  def change do
    create table(:accounts_user_roles) do
      add :user_id, references(:accounts_users, on_delete: :nothing)
      add :role_id, references(:accounts_roles, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts_user_roles, [:user_id])
    create index(:accounts_user_roles, [:role_id])
    create unique_index(:accounts_user_roles, [:user_id, :role_id])
  end
end

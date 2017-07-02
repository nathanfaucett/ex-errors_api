defmodule NotesApi.Repo.Migrations.CreateNotesApi.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      
      add :email, :string
      add :username, :string
      add :token, :string

      timestamps()
    end

    create unique_index(:accounts_users, [:email])
    create unique_index(:accounts_users, [:token])
  end
end

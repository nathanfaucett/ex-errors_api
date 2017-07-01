defmodule NotesApi.Repo.Migrations.CreateNotesApi.Accounts.Role do
  use Ecto.Migration

  def change do
    create table(:accounts_roles) do
      add :name, :string

      timestamps()
    end

    create unique_index(:accounts_roles, [:name])
  end
end

defmodule ErrorsApi.Repo.Migrations.CreateErrorsApi.Projects.Project do
  use Ecto.Migration

  def change do
    create table(:projects_projects) do

      add :user_id, references(:accounts_users, on_delete: :nothing, null: false)
      add :name, :string
      add :token, :string

      add :error_callback, :string
      add :new_error_callback, :string

      timestamps()
    end

  end
end

defmodule ErrorsApi.Repo.Migrations.CreateErrorsApi.Projects.ProjectMeta do
  use Ecto.Migration

  def change do
    create table(:projects_meta) do

      add :project_error_id, references(:projects_errors, on_delete: :nothing, null: false)
      add :count, :integer, default: 0
      add :meta, :string

      timestamps()
    end

  end
end

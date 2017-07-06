defmodule ErrorsApi.Repo.Migrations.CreateErrorsApi.Projects.ProjectError do
  use Ecto.Migration

  def change do
    create table(:projects_errors) do

      add :project_id, references(:projects_projects, on_delete: :nothing, null: false)
      add :name, :string
      add :count, :integer
      add :occurred_at, :utc_datetime
      add :stack_trace, :string

      timestamps()
    end

  end
end

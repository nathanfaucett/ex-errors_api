defmodule ErrorsApi.Repo.Migrations.CreateErrorsApi.Projects.ProjectError do
  use Ecto.Migration

  def change do
    create table(:projects_errors) do

      add :project_id, references(:projects_projects, on_delete: :nothing, null: false)
      add :stack_trace, :string

      timestamps()
    end

  end
end

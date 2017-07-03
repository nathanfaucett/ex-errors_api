defmodule ErrorsApi.Web.ProjectView do
  use ErrorsApi.Web, :view
  alias ErrorsApi.Web.ProjectView

  def render("index.json", %{projects: projects}) do
    %{data: render_many(projects, ProjectView, "project.json")}
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id,
      user_id: project.user_id,
      name: project.name,
      token: project.token}
  end

  def render("secure_project.json", %{project: project}) do
    %{id: project.id,
      name: project.name}
  end
end

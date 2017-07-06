defmodule ErrorsApi.Web.ProjectErrorView do
  use ErrorsApi.Web, :view
  alias ErrorsApi.Web.ProjectErrorView

  def render("index.json", %{errors: errors}) do
    %{data: render_many(errors, ProjectErrorView, "project_error.json")}
  end

  def render("show.json", %{project_error: project_error}) do
    %{data: render_one(project_error, ProjectErrorView, "project_error.json")}
  end

  def render("project_error.json", %{project_error: project_error}) do
    %{id: project_error.id,
      project_id: project_error.project_id,
      occurred_at: project_error.occurred_at,
      count: project_error.count,
      stack_trace: project_error.stack_trace,
      meta: render_many(project_error.meta, ErrorsApi.Web.ProjectMetaView, "project_meta.json")}
  end

  def render("secure_project_error.json", %{project_error: project_error}) do
    %{id: project_error.id,
      occurred_at: project_error.occurred_at,
      count: project_error.count,
      stack_trace: project_error.stack_trace,
      meta: render_many(project_error.meta, ErrorsApi.Web.ProjectMetaView, "secure_project_meta.json")}
  end
end

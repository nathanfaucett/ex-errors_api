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
      count: project_error.count,
      stack_trace: project_error.stack_trace}
  end
end
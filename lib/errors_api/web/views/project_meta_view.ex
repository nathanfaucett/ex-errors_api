defmodule ErrorsApi.Web.ProjectMetaView do
  use ErrorsApi.Web, :view
  alias ErrorsApi.Web.ProjectMetaView

  def render("index.json", %{meta: meta}) do
    %{data: render_many(meta, ProjectMetaView, "project_meta.json")}
  end

  def render("show.json", %{project_meta: project_meta}) do
    %{data: render_one(project_meta, ProjectMetaView, "project_meta.json")}
  end

  def render("project_meta.json", %{project_meta: project_meta}) do
    %{id: project_meta.id,
      project_error_id: project_meta.project_error_id,
      count: project_meta.count,
      data: project_meta.meta}
  end
end

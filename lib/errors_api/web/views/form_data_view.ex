defmodule ErrorsApi.Web.FormDataView do

  use ErrorsApi.Web, :view

  def render("fetch.json", assigns) do
    %{ value: assigns.value }
  end

end

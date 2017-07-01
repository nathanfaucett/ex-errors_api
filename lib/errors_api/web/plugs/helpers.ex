defmodule ErrorsApi.Web.Plugs.Helpers do

  use Phoenix.Controller

  def halt_execution(conn, status, template) do
    conn
      |> put_status(status)
      |> put_view(ErrorsApi.Web.ErrorView)
      |> render(template)
      |> halt
  end

end

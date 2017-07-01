defmodule ErrorsApi.Utils.Config do

  def app_get(key) do
    Application.get_env(:errors_api, ErrorsApi.Web.Endpoint)[key]
  end

end

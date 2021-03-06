defmodule ErrorsApi.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :errors_api

  alias ErrorsApi.Utils.Config

  socket "/socket", ErrorsApi.Web.UserSocket

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # Cors
  plug CORSPlug, origin: [Config.app_get(:frontend_origin)]
  # Locale and Region Detection
  plug ErrorsApi.Web.Plugs.UserLocale

  plug ErrorsApi.Web.Router

  @doc """
  Dynamically loads configuration from the system environment
  on startup.

  It receives the endpoint configuration from the config files
  and must return the updated configuration.
  """
  def load_from_system_env(config) do
    port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
    {:ok, Keyword.put(config, :http, [:inet6, port: port])}
  end
end

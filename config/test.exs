use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :errors_api, ErrorsApi.Web.Endpoint,
  http: [port: 4001],
  server: false,
  frontend_origin: "http://localhost:8080"

config :cors_plug,
  headers: [
    "Authorization", "Content-Type", "Accept", "Origin",
    "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
    "Keep-Alive", "X-Requested-With", "If-Modified-Since",
    "X-CSRF-Token", "X-Errors-User-Token"]

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :errors_api, ErrorsApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "dev",
  password: "dev",
  database: "errors_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

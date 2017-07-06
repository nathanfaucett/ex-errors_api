use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :errors_api, ErrorsApi.Web.Endpoint,
  http: [port: 4001],
  server: false,
  frontend_origin: "http://localhost:8080"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :errors_api, ErrorsApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "errors_api_test",
  hostname: if(System.get_env("CI"), do: "postgres", else: "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

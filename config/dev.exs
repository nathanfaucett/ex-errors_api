use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :errors_api, ErrorsApi.Web.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20


config :oauth2,
  debug: true,
  active_providers: ["github"],
  github: [client_id: "18c3ebb231d63a77c602",
           client_secret: "541feec95e99e36715f888f107b14149c6211dfa",
           redirect_uri: "http://localhost:4000/api/oauth2_services/github/callback"],
  google: [client_id: "",
           client_secret: "",
           redirect_uri: "http://localhost:4000/api/oauth2_services/google/callback"],
  facebook: [client_id: "",
           client_secret: "",
           redirect_uri: "http://localhost:4000/api/oauth2_services/facebook/callback"]


# Configure your database
config :errors_api, ErrorsApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "dev",
  password: "dev",
  database: "errors_api_dev",
  hostname: "localhost",
  pool_size: 10

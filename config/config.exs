# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :errors_api,
  ecto_repos: [ErrorsApi.Repo]

# Configures the endpoint
config :errors_api, ErrorsApi.Web.Endpoint,
  default_locale: "en",
  supported_locales: ["en","de"],

  api_user_token_header: "x-errors-user-token",
  api_user_locale_header: "x-errors-user-locale",
  api_project_token_header: "x-errors-project-token",

  url: [host: "localhost"],
  secret_key_base: "lgurMFsqGejlkO2itvyXac/62wlN03VT7fR30DVArLKlajlltOnlTVW66B+Utg5p",
  render_errors: [view: ErrorsApi.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: ErrorsApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :cors_plug,
 headers: [
   "Authorization", "Content-Type", "Accept", "Origin",
   "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
   "Keep-Alive", "X-Requested-With", "If-Modified-Since",
   "X-CSRF-Token", "X-Errors-User-Token"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

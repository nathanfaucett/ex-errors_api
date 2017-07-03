defmodule ErrorsApi.Web.Router do
  use ErrorsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ErrorsApi.Web.Plugs.Authentication
  end

  pipeline :project_auth do
    plug ErrorsApi.Web.Plugs.ProjectAuthentication
  end

  scope "/api", ErrorsApi.Web do
    pipe_through :api

    # OAuth2 Services
    get "/oauth2_services", OAuth2Controller, :index
    get "/oauth2_services/:provider", OAuth2Controller, :show
    get "/oauth2_services/:provider/callback", OAuth2Controller, :callback

    # form data for frontends
    get "/form_data/:key", FormDataController, :fetch

    pipe_through :auth

    # Users
    get "/users/current_user", UserController, :get_current_user

    # Projects
    resources "/projects", ProjectController, only: [:index, :show, :create, :update, :delete] do
      patch "/regenerate_token", ProjectController, :regenerate_token
      resources "/errors", ProjectErrorController, only: [:index, :show, :delete]
    end

    # Project Errors
    pipe_through :project_auth
    post "/project_errors", ProjectErrorController, :create

  end
end

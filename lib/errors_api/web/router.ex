defmodule ErrorsApi.Web.Router do
  use ErrorsApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ErrorsApi.Web.Plugs.Authentication
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
    get "/users/current_user", UsersController, :get_current_user
    post "/users/complete_registration", UsersController, :complete_registration

  end
end

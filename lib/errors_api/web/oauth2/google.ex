defmodule ErrorsApi.Web.OAuth2.Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  """
  use OAuth2.Strategy

  defp config() do
    [strategy: __MODULE__,
     site: "https://accounts.google.com",
     authorize_url: "/o/oauth2/auth",
     token_url: "/o/oauth2/token"]
  end

  def client() do
    Application.get_env(:oauth2, :google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end


  # Google Specific Helpers
  # see: https://developers.google.com/identity/protocols/googlescopes
  def get_scopes() do
    scopes = ["https://www.googleapis.com/auth/userinfo.email",          # view email address
              "https://www.googleapis.com/auth/userinfo.profile",        # view basic profile info
              "https://www.googleapis.com/auth/user.phonenumbers.read"]  # view user's phone numbers
    Enum.reduce(scopes, "", fn(scope, acc) -> "#{acc} #{scope}" end)
  end
end

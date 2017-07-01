defmodule ErrorsApi.Web.OAuth2.Facebook do
  @moduledoc """
  An OAuth2 strategy for Facebook.
  """
  use OAuth2.Strategy

  defp config() do
    [strategy: __MODULE__,
     site: "https://graph.facebook.com",
     authorize_url: "https://www.facebook.com/dialog/oauth",
     token_url: "/oauth/access_token"]
  end

  def client() do
    Application.get_env(:oauth2, :facebook)
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

  # Facebook Specific Helpers
  # see: https://developers.facebook.com/docs/facebook-login/permissions/
  def get_scopes() do
    "email,public_profile"
  end

  def get_fields() do
    "id,email,name"
  end
end

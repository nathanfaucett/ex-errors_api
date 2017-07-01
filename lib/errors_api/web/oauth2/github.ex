defmodule ErrorsApi.Web.OAuth2.Github do
  @moduledoc """
  An OAuth2 strategy for Github.
  """
  use OAuth2.Strategy

  defp config() do
    [strategy: __MODULE__,
     site: "https://api.github.com",
     authorize_url: "https://github.com/login/oauth/authorize",
     token_url: "https://github.com/login/oauth/access_token"]
  end

  def client() do
    Application.get_env(:oauth2, :github)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!() do
    OAuth2.Client.authorize_url!(client(), scope: "user")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end


end

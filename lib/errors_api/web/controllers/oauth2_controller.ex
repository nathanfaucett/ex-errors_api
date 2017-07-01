defmodule ErrorsApi.Web.OAuth2Controller do

  use ErrorsApi.Web, :controller

  alias ErrorsApi.Web.OAuth2.Github, as: Github
  alias ErrorsApi.Web.OAuth2.Google, as: Google
  alias ErrorsApi.Web.OAuth2.Facebook, as: Facebook
  alias ErrorsApi.Accounts, as: Accounts

  def index(conn, _params) do
    active_provider_names = Application.get_env(:oauth2, :active_providers)
    active_providers = Enum.map(active_provider_names, fn(name) ->
      %{  name: name,
          auth_url: get_auth_url_for_provider(name) }
    end)
    render(conn, "index.json", %{ oauth2_providers: active_providers })
  end

  def show(conn, %{ "provider" => provider }) do
    auth_url = get_auth_url_for_provider(provider)
    render(conn, "show.json", auth_url: auth_url)
  end

  def callback(conn, %{ "provider" => provider, "code" => code }) do
    # exchange the code for an access_token
    client = get_client_for_provider(provider, code)

    # request the user's data using the access_token
    # todo: add error handling for when email is not present
    user_data = get_user!(provider, client)

    # create a user since we have an email
    user = Accounts.find_or_create_user!(provider, user_data)

    access_token = Accounts.get_access_token(user)

    # add get_user by access_token
    redirect(conn, external: "#{System.get_env("HT_FRONTEND_HOST")}/oauth2/#{access_token}")
  end

  def callback(conn, _params) do
    redirect(conn, external: "#{System.get_env("HT_FRONTEND_HOST")}/oauth2_error")
  end

  defp get_auth_url_for_provider("github"), do: Github.authorize_url!()
  defp get_auth_url_for_provider("google"), do: Google.authorize_url!(scope: Google.get_scopes())
  defp get_auth_url_for_provider("facebook"), do: Facebook.authorize_url!(scope: Facebook.get_scopes())
  defp get_auth_url_for_provider(_other), do: raise("No matching provider")

  defp get_client_for_provider("github", code), do: Github.get_token!(code: code)
  defp get_client_for_provider("google", code), do: Google.get_token!(code: code)
  defp get_client_for_provider("facebook", code), do: Facebook.get_token!(code: code)
  defp get_client_for_provider(_other, _code), do: raise("No matching provider available")

  defp get_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    user
  end

  defp get_user!("google", client) do
    %{body: user} = OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    user
  end

  defp get_user!("facebook", client) do
    %{body: user} = OAuth2.Client.get!(client, "/me?fields=#{Facebook.get_fields()}")
    user
  end

  defp get_user!(_probider, _client), do: raise("No matching provider available")

end

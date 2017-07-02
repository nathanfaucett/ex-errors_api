defmodule ErrorsApi.Accounts do

  alias ErrorsApi.Repo
  alias Ecto.Changeset


  alias ErrorsApi.Accounts.OAuth2
  alias ErrorsApi.Accounts.User
  alias ErrorsApi.Utils.Crypto

  def find_or_create_user!(provider, user_data) do
    email = Map.get(user_data, "email", Map.get(user_data, :email))
    {:ok, encoded_data} = Poison.encode(user_data)

    auth = Repo.get_by(OAuth2, email: email, provider: provider)
    user = case Repo.get_by(User, email: email) do
      nil -> insert_user_for!(provider, user_data)
      user -> user
    end

    if is_nil(auth) do
      auth = Repo.insert!(%OAuth2{
        provider: provider,
        email: email,
        user: user,
        data: encoded_data })
    else
      cs = Changeset.change(auth, data: encoded_data)
      Repo.update!(cs)
    end

    user
  end


  defp insert_user_for!("github", user_data) do
    Repo.insert!(%User{
      email: Map.get(user_data, "email", Map.get(user_data, :email)),
      username: Map.get(user_data, "login", Map.get(user_data, :login)),
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!("google", user_data) do
    Repo.insert!(%User{
      email: Map.get(user_data, "email", Map.get(user_data, :email)),
      username: Map.get(user_data, "name", Map.get(user_data, :name)),
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!("facebook", user_data) do
    Repo.insert!(%User{
      email: Map.get(user_data, "email", Map.get(user_data, :email)),
      username: Map.get(user_data, "name", Map.get(user_data, :name)),
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!(_provider, _data), do: raise("No matching provider available")


  def get_access_token(%User{ token: token }), do: token
  def get_user_by_token(token), do: Repo.get_by(User, token: token)

end

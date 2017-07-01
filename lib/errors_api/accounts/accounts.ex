defmodule ErrorsApi.Accounts do

  alias ErrorsApi.Repo
  alias Ecto.Changeset


  alias ErrorsApi.Accounts.OAuth2
  alias ErrorsApi.Accounts.User
  alias ErrorsApi.Accounts.UserInfo
  alias ErrorsApi.Accounts.Role
  alias ErrorsApi.Accounts.UserRole
  alias ErrorsApi.Utils.Crypto

  # macros
  import Ecto.Query

  def create_role!(role_name) do
    Changeset.change(%Role{}, %{ name: role_name })
    |> Repo.insert!()
  end

  def user_add_role!(%User{} = user, role_name) do
    role = Repo.get_by!(Role, name: role_name)
    Changeset.change(%UserRole{}, %{ user_id: user.id, role_id: role.id })
    |> Repo.insert!()
  end

  def user_has_role?(%User{} = user, role_name) do
    from(ur in UserRole, join: r in Role,
         where: ur.user_id == ^user.id and r.name == ^role_name)
    |> Repo.all()
    |> Enum.count() == 1
  end

  def find_or_create_user!(provider, user_data) do
    email = user_data["email"]
    {:ok, encoded_data} = Poison.encode(user_data)

    auth = Repo.get_by(OAuth2, email: email, provider: provider)
    user = case Repo.get_by(User, email: email) do
      nil -> insert_user_for!(provider, user_data)
      user -> user
    end

    if is_nil(auth) do
      auth = Repo.insert!(%OAuth2{
        provider: provider,
        email: user_data["email"],
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
      email: user_data["email"],
      username: user_data["login"],
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!("google", user_data) do
    Repo.insert!(%User{
      email: user_data["email"],
      username: user_data["name"],
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!("facebook", user_data) do
    Repo.insert!(%User{
      email: user_data["email"],
      username: user_data["name"],
      token: Crypto.secure_random(64)})
  end
  defp insert_user_for!(_provider, _data), do: raise("No matching provider available")


  def get_access_token(%User{ token: token }), do: token
  def get_user_by_token(token), do: Repo.get_by(User, token: token)


  def complete_registration(user, params) do

    user_info = Repo.get_by(UserInfo, user_id: user.id)

    if is_nil(user_info) do
      attrs = %{user_id: user.id,
                 terms_of_service: params["terms_of_service"],
                 learning_disability: params["learning_disability"],
                 learning_disability_text: "#{Enum.join(params["learning_disabilities"], "/")} | #{params["learning_disability_text"]}",
                 native_language: params["native_language"] && String.downcase(params["native_language"])}

      {:ok, birth_date} = Timex.parse(params["date_of_birth"], "{ISO:Extended}")
      attrs = Map.put(attrs, :date_of_birth, birth_date)

      UserInfo.changeset(%UserInfo{}, attrs)
      |> Repo.insert!()

    else
      cs = Changeset.change(user_info, %{
          native_language: params["native_language"],
          terms_of_service: params["terms_of_service"],
          date_of_birth: params["data_of_birth"],
          learning_disability: params["learning_disability"],
          learning_disability_text: params["learning_disability_text"] })
     user_info = Repo.update!(cs)
    end

    user_cs = Changeset.change(user, %{completed: true})
    Repo.update!(user_cs)
  end

end

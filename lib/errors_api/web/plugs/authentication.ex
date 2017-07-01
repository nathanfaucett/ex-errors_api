defmodule ErrorsApi.Web.Plugs.Authentication do
  use Phoenix.Controller

  alias ErrorsApi.Accounts

  import ErrorsApi.Web.Plugs.Helpers, only: [halt_execution: 3]

  def init(default), do: default

  def call(conn, _default) do

    # get access_token from the headers
    access_token = Plug.Conn.get_req_header(conn, "x-notes-user-token")
                 |> List.first()

    # if access_token has not been set
    if is_nil(access_token) do

      halt_execution(conn, :unauthorized, "401.json")

    else

      # attempt to get user from session
      user = Accounts.get_user_by_token(access_token)

      if user do
        assign(conn, :current_user, user)
      else
        halt_execution(conn, :unauthorized, "401.json")
      end

    end
  end

end

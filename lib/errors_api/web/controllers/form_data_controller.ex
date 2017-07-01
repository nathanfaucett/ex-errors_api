defmodule ErrorsApi.Web.FormDataController do
  use ErrorsApi.Web, :controller

  alias ErrorsApi.Utils.FormData, as: FormData
  alias ErrorsApi.Errors

  def fetch(conn, %{ "key" => key }), do: fetch_data_by_key(conn, key)

  defp fetch_data_by_key(conn, "language_codes"),
    do: render_data(conn, value: FormData.language_codes())

  defp fetch_data_by_key(conn, "learning_disabilities"),
    do: render_data(conn, value: FormData.learning_disabilities())

  defp fetch_data_by_key(conn, "supported_locales"),
    do: render_data(conn, value: FormData.supported_locales())

  defp fetch_data_by_key(_conn, _other), do: raise Errors.InvalidRequestParameter, message: "invalid key value"

  defp render_data(conn, params), do: render(conn, "fetch.json", params)



end

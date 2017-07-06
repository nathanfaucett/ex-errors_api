defmodule ErrorsApi.Web.Plugs.UserLocale do
  use Phoenix.Controller

  alias ErrorsApi.Utils.Config, as: Config

  @supported_locales Config.app_get(:supported_locales)
  @default_locale Config.app_get(:default_locale)

  def init(default), do: default

  def call(conn, _default) do

    # get accept language from the headers
    accept_languages = Plug.Conn.get_req_header(conn, "accept-language")
                     |> List.first()
                     |> String.split(";")
                     |> filter_accept_languages()
                     |> List.flatten()

    # get current locale from the headers
    user_locale  = Plug.Conn.get_req_header(conn, Config.app_get(:api_user_locale_header))
                   |> List.first()

    # ensure we always have a locale
    locale = merge_locale(user_locale, accept_languages)
    conn = assign(conn, :locale, locale)

    # todo: possibly add regions support
    assign(conn, :locale, locale)
  end

  defp  filter_accept_languages(accept_languages) do
    Enum.map(accept_languages, fn(x) ->
      parts = String.split(x, ",")
      Enum.filter(parts, fn(p) ->
        if String.match?(p, ~r/q=[0-9\.]+/) do
          false
        else
          true
        end
      end)
    end)
  end

  defp merge_locale(nil, []), do: @default_locale
  defp merge_locale(nil, accept_languages) do
    requested_locale = intersect_supported(accept_languages)
                     |> List.first()

    requested_locale || @default_locale
  end

  defp merge_locale(user_locale, []) do
    if Enum.member?(@supported_locales, user_locale) do
      user_locale
    else
      @default_locale
    end
  end

  defp merge_locale(user_locale, accept_languages) do
    requested_locale = intersect_supported(accept_languages)
                     |> List.first()

    if Enum.member?(@supported_locales, user_locale) do
      user_locale
    else
      requested_locale || @default_locale
    end
  end

  defp intersect_supported(locales) do
    Enum.filter(locales, fn(x) -> Enum.member?(@supported_locales, x) end)
  end


end

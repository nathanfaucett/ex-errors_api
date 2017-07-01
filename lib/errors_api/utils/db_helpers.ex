defmodule ErrorsApi.Utils.DbHelpers do

  def to_url_key(string) do
    string
    |> String.trim()
    |> String.replace(" ", "-")
    |> String.downcase()
  end


end

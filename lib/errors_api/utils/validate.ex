defmodule ErrorsApi.Utils.Validate do
  import Ecto.Changeset

  def url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn(_, url) ->
      case URI.parse(url) do
        %URI{scheme: nil} -> [{field, options[:message] || "Invalid scheme"}]
        %URI{host: nil} -> [{field, options[:message] || "Invalid host"}]
        %URI{path: nil} -> [{field, options[:message] || "Invalid path"}]
        _ -> []
      end
    end)
  end

end

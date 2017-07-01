defmodule ErrorsApi.Errors.InvalidRequestParameter do
  defexception message: nil, plug_status: 422
end

defimpl Plug.Exception, for: ErrorsApi.Errors.InvalidRequestParameter do
  def status(_), do: 422
end

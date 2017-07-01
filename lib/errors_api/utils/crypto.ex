defmodule ErrorsApi.Utils.Crypto do

  def secure_random(n) do
    :crypto.hash(:sha256, :crypto.strong_rand_bytes(n)) |> Base.url_encode64()
  end

end

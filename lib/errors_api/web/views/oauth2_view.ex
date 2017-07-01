defmodule ErrorsApi.Web.OAuth2View do

  use ErrorsApi.Web, :view

  def render("index.json", assigns) do
    %{ oauth2_providers: assigns[:oauth2_providers] }
  end

  def render("show.json", assigns) do
    %{ auth_url: assigns[:auth_url] }
  end

end

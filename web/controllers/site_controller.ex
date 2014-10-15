defmodule Bouncer.Api.SiteController do
  use Phoenix.Controller

  def insert(conn, params) do
    site = %Bouncer.Site{
      id: params["id"],
      host: params["host"],
      name: params["name"],
    }

    Bouncer.Site.insert(site)

    json conn, JSON.encode!(site)
  end
end

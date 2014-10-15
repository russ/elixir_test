defmodule Bouncer.Api.CampaignController do
  use Phoenix.Controller

  def insert(conn, params) do
    campaign = %Bouncer.Campaign{
      id: params["id"],
      affiliate: params["affiliate"],
    }

    Bouncer.Campaign.insert(campaign)

    json conn, JSON.encode!(campaign)
  end
end

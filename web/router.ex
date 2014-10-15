defmodule Bouncer.Router do
  use Phoenix.Router

  get "/track/:stan_code/*path", Bouncer.TrackController, :track
  get "/track/:stan_code", Bouncer.TrackController, :track

  put "/api/campaigns.json", Bouncer.Api.CampaignController, :insert
  put "/api/sites.json", Bouncer.Api.SiteController, :insert
  put "/api/tours.json", Bouncer.Api.TourController, :insert
end

defmodule Bouncer.Router do
  use Phoenix.Router

  get "/", Bouncer.PageController, :index, as: :pages
  get "/track/:stan_code", Bouncer.TrackController, :track

end

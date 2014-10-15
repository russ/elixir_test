defmodule Bouncer.Api.TourController do
  use Phoenix.Controller

  def insert(conn, params) do
    tour = %Bouncer.Tour{
      id: params["id"],
      url: params["url"],
    }

    Bouncer.Tour.insert(tour)

    json conn, JSON.encode!(tour)
  end
end

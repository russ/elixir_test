defmodule Bouncer.Tour do
  alias Exredis.Api, as: R

  defstruct id: nil, url: nil

  def find(id) do
    %Bouncer.Tour{
      id: id,
      url: R.get("events:tours:#{id}")
    }
  end

  def insert(tour) do
    R.set("events:tours:#{tour.id}", tour.url)
  end
end

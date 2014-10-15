defmodule Bouncer.Campaign do
  alias Exredis.Api, as: R

  defstruct id: nil, affiliate: nil

  def find(id) do
    %Bouncer.Campaign{
      id: id,
      affiliate: R.get("events:campaigns:#{id}")
    }
  end

  def insert(campaign) do
    R.set("events:campaigns:#{campaign.id}", campaign.affiliate)
  end
end

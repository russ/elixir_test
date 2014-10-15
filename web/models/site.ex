defmodule Bouncer.Site do
  alias Exredis.Api, as: R

  defstruct id: nil, name: nil, host: nil

  def find(id) do
    site = R.hgetall("events:sites:#{id}")
    %Bouncer.Site{
      id: id,
      host: site["host"],
      name: site["name"]
    }
  end

  def find_by_host(host) do
    Bouncer.Site.find(R.get("events:sites:by_host:#{host}"))
  end

  def insert(site) do
    R.set("events:sites:by_host:#{site.host}", site.id)
    R.hmset("events:sites:#{site.id}", ["host", site.host, "name", site.name])
  end
end

defmodule Bouncer.Event do
  use Timex
  alias Exredis.Api, as: R

  defstruct raw: nil, unique: nil,
            site: "0", program: "0", campaign: "0",
            path: "", referrer: "", time: Date.universal(Date.now)

  def store(%Bouncer.Event{unique: false} = event) do
    save_referrer(event)
    save_as("raw", event)
  end

  def store(%Bouncer.Event{unique: true} = event) do
    save_referrer(event)
    save_as("raw", event)
    save_as("unique", event)
  end

  defp formatted_date(event) do
    DateFormat.format!(event.time, "%Y%m%d", :strftime)
  end

  defp save_referrer(event) do
    date = DateFormat.format!(event.time, "%Y%m%d", :strftime)
    hash = MD5.hash(event.referrer)
    campaign = Bouncer.Campaign.find(event.campaign)
    referrer_key = "events:referers:#{date}:#{campaign.affiliate}:#{hash}"

    R.set("events:urls:#{hash}", event.referrer)
    R.sadd("events:urls:#{date}:#{event.campaign}", hash)
    R.hmset(referrer_key, ["site", event.site, "program", event.program, "campaign", event.campaign, "path", event.path, "referrer", event.referrer])
    R.hincrby(referrer_key, "raw", 1)
    if event.unique do R.hincrby(referrer_key, "unique", 1) end
  end

  defp save_as(type, event) do
    date = DateFormat.format!(event.time, "%Y%m%d", :strftime)
    campaign = Bouncer.Campaign.find(event.campaign)

    R.incr("events:#{type}:#{date}")
    R.incr("events:#{type}:#{date}:site:#{event.site}")
    R.incr("events:#{type}:#{date}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:campaign:#{event.campaign}")

    R.incr("events:#{type}:#{date}:site:#{event.site}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:site:#{event.site}:campaign:#{event.campaign}")
    R.incr("events:#{type}:#{date}:campaign:#{event.campaign}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:site:#{event.site}:program:#{event.program}:campaign:#{event.campaign}")

    R.incr("events:#{type}:#{date}:#{campaign.affiliate}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:site:#{event.site}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:campaign:#{event.campaign}")

    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:site:#{event.site}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:site:#{event.site}:campaign:#{event.campaign}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:campaign:#{event.campaign}:program:#{event.program}")
    R.incr("events:#{type}:#{date}:#{campaign.affiliate}:site:#{event.site}:program:#{event.program}:campaign:#{event.campaign}")
  end
end

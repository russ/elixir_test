defmodule Bouncer.Event do
  use Timex
  alias Exredis.Api, as: R

  defstruct site: "0",
            program: "0",
            campaign: "0",
            referrer: "",
            time: Date.universal(Date.now)

  def store(event) do
    client = Exredis.start_using_connection_string("redis://127.0.0.1:6379")
    date = DateFormat.format!(event.time, "%Y%m%d", :strftime)
    key = to_string(:io_lib.format("events:raw:~s:site:~s", [date, event.site]))
    client |> R.incr(key)
  end
end

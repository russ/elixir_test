defmodule Bouncer.TrackController do
  use Phoenix.Controller
  use Timex

  def track(conn, params) do
    code = Bouncer.StanCode.decode(params["stan_code"])

    spawn fn ->
      Bouncer.Event.store(event_from_request(conn, params, code))
    end

    set_cookie(conn, code) |> redirect("http://google.com")
  end

  defp event_from_request(conn, params, code) do
    %Bouncer.Event{
      site: code.site,
      program: code.program,
      campaign: code.campaign,
      referrer: conn |> get_req_header("referer") |> List.last
    }
  end

  defp set_cookie(conn, code) do
    put_resp_cookie(
      conn, "stan", Bouncer.StanCode.to_string(code), cookie_options)
  end

  defp cookie_options do
    [ path: "/", max_age: 60 * 60 * 24 * 90 ]
  end
end

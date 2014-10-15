defmodule Bouncer.TrackController do
  use Phoenix.Controller
  use Timex

  def track(conn, params) do
    code = Bouncer.StanCode.decode(params["stan_code"])
    Session.start(conn)
    |> set_cookie(code)
    |> redirect_for_code(code, params)
  end


  defp redirect_for_code(conn, %Bouncer.StanCode{invalid: true} = code, params) do
    site = Bouncer.Site.find_by_host(hd(conn |> get_req_header("host")))
    conn |> redirect("http://#{site.host}")
  end

  defp redirect_for_code(conn, %Bouncer.StanCode{invalid: false} = code, params) do
    event = event_from_request(conn, params, code)
    if !Session.exists?(conn) do event = %{event | unique: true } end
    spawn fn -> Bouncer.Event.store(event) end
    url = redirect_url_for_request(code, event, params)
    conn |> redirect(url)
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
      conn, "stan", Bouncer.StanCode.encode(code),
      [ path: "/", max_age: 60 * 60 * 24 * 90 ])
  end

  defp append_code_to_url(url, code) do
    append = if String.contains?(url, "?") do "&" else "?" end
    "#{url}#{append}stan=#{code.code}"
  end

  defp redirect_url_for_request(%Bouncer.StanCode{tour: ""} = code, event, params) do
    site = Bouncer.Site.find(event.site)
    url = "http://#{site.host}"
    if params["path"] do url = "#{url}/#{params["path"]}" end
    append_code_to_url(url, code)
  end

  defp redirect_url_for_request(code, event, params) do
    url = Bouncer.Tour.find(code.tour).url
    append_code_to_url(url, code)
  end
end

defmodule Session do
  use Phoenix.Controller

  def exists?(conn) do
    conn.req_cookies["stan_session"] != nil
  end

  def start(conn) do
    put_resp_cookie(conn, "stan_session", "1234567890", cookie_options)
  end

  defp cookie_options do
    [ path: "/", max_age: 60 * 60 * 24 * 90 ]
  end
end

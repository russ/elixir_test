use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, Bouncer.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_bouncer_key",
  session_secret: "Z!PVL@&X_9$^2I5IU*!M2^(S(QY@U2ZE!I=LC0C7*@6=FDD(EW)VYCEJYF12)M3D856OXXRQ"

config :logger, :console,
  level: :info,
  metadata: [:request_id]


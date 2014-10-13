use Mix.Config

config :phoenix, Bouncer.Router,
  port: System.get_env("PORT") || 4000,
  ssl: false,
  host: "localhost",
  cookies: true,
  session_key: "_bouncer_key",
  session_secret: "Z!PVL@&X_9$^2I5IU*!M2^(S(QY@U2ZE!I=LC0C7*@6=FDD(EW)VYCEJYF12)M3D856OXXRQ",
  debug_errors: true

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug



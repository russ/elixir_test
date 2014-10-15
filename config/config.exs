# This file is responsible for configuring your application
use Mix.Config

# Note this file is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project.

config :phoenix, Bouncer.Router,
  port: System.get_env("PORT"),
  ssl: false,
  static_assets: true,
  cookies: true,
  session_key: "_stan_key",
  session_secret: "Z!PVL@&X_9$^2I5IU*!M2^(S(QY@U2ZE!I=LC0C7*@6=FDD(EW)VYCEJYF12)M3D856OXXRQ",
  catch_errors: true,
  debug_errors: false,
  error_controller: Bouncer.PageController

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"

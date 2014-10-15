defmodule Bouncer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # exredis_pid = Exredis.start_using_connection_string("redis://127.0.0.1:6379")
    # Process.register(exredis_pid, :exredis)

    children = [
      # Define workers and child supervisors to be supervised
      # worker(TestApp.Worker, [arg1, arg2, arg3])
      worker(Bouncer.Router, [], function: :start),
      worker(Exredis, ["127.0.0.1", 6379])
    ]

    opts = [strategy: :one_for_one, name: Bouncer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

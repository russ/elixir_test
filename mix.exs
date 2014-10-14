defmodule Bouncer.Mixfile do
  use Mix.Project

  def project do
    [ app: :bouncer,
      version: "0.0.1",
      elixir: "~> 1.0.0-rc1",
      elixirc_paths: ["lib", "web"],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Bouncer, [] },
      applications: [:phoenix, :cowboy, :logger]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, "0.4.1"},
      {:cowboy, "~> 1.0.0"},
      {:exrm, "~> 0.14.3"},
      {:apex, "~>0.3.0"},
      {:exredis, github: "artemeff/exredis", tag: "0.1.0"},
      {:timex, "~> 0.12.9"},
      {:earmark, ">= 0.0.0"},
      {:ex_doc, github: "elixir-lang/ex_doc"}
      # {:bugsnag, "~> 0.0.1" }
    ]
  end
end

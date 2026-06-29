defmodule CjkDoubleStroke.MixProject do
  use Mix.Project

  def project do
    [
      app: :cjk_double_stroke,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: true,
      mod: {CjkDoubleStroke.Application, []},
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mnesia]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 3.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end

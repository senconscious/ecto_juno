defmodule EctoJuno.MixProject do
  use Mix.Project

  @source_url "https://github.com/senconscious/ecto_juno"
  @version "0.3.0"

  def project do
    [
      app: :ecto_juno,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [ignore_modules: test_ignored_modules()],
      description: "A simple query sorting library for Elixir",
      package: package(),
      source_url: @source_url,
      docs: [
        extras: ["README.md"]
      ],
      preferred_cli_env: [
        check: :test,
        check_code_health: :test,
        check_coverage: :test
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        ignore_warnings: ".dialyzer_ignore.exs"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.8"},
      {:ecto_sql, "~> 3.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:postgrex, ">= 0.15.0", only: :test}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package() do
    [
      files: ~w(.formatter.exs mix.exs README.md CHANGELOG.md lib),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp test_ignored_modules do
    [
      EctoJuno.Accounts.User,
      EctoJuno.Repo,
      EctoJuno.Posts.Post,
      EctoJuno.Fixtures
    ]
  end

  defp aliases do
    [
      check: ["check_code_health", "check_coverage"],
      check_code_health: [
        "format --check-formatted",
        "credo --strict",
        "dialyzer --format github"
      ],
      check_coverage: "test --cover"
    ]
  end
end

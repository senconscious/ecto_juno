defmodule EctoJuno.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_juno,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      env: env(),
      preferred_cli_env: [
        "ecto.setup": :test,
        "ecto.reset": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: mod(Mix.env())
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.8"},
      {:ecto_sql, "~> 3.0", only: [:test]},
      {:postgrex, ">= 0.0.0", only: [:test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies load application only for test environment
  defp mod(:test) do
    {EctoJuno.Application, []}
  end
  defp mod(_), do: {}

  defp aliases do
    [
      "ecto.setup": ["ecto.create --quiet", "ecto.migrate --quiet"],
      test: ["ecto.setup", "test"],
      "ecto.reset": ["ecto.drop --quiet", "ecto.setup"]
    ]
  end

  defp env() do
    [sort_by: :inserted_at, sort_direction: :asc]
  end
end

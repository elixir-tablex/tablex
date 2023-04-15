defmodule Tablex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tablex,
      version: "0.1.0-alpha.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:nimble_parsec, "~> 1.3"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w[README.md guides/nested_fields.md],
      before_closing_head_tag: &before_closing_head_tag/1,
      source_url: "https://github.com/qhwa/tablex"
    ]
  end

  defp before_closing_head_tag(:html) do
    """
    <style>
      table.tablex {
        border: solid;
        border-spacing: 0;
      }

      table.tablex th, table.tablex td {
        text-transform: none;
        vertical-align: middle;
      }

      table.tablex col.output {
        background-color: #EEE;
      }

      table.tablex, table.tablex th, table.tablex td {
        border-collapse: collapse;
      }

      table.tablex th, table.tablex td {
        padding: 0.5em;
        border: 1px solid;
        border-color: #DDD;
      }

      table.tablex th {
        border-bottom: double;
      }

      table.tablex td.input + td.output {
        border-left: double;
      }

      table.tablex th.input + th.output {
        border-left: double;
      }

      table.tablex th.hit-policy {
        border-right: double;
      }

      table.tablex td.rule-number {
        border-right: double;
        text-align: center;
      }
    </style>
    """
  end

  defp before_closing_head_tag(_) do
    ""
  end

  defp package do
    [
      name: "tablex",
      description: "Organize business rules with decision tables.",
      files: ~w[lib mix.exs],
      licenses: ~w[MIT],
      links: %{
        "Github" => "https://github.com/qhwa/tablex"
      }
    ]
  end
end

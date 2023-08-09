defmodule Tablex.MixProject do
  use Mix.Project

  def project do
    [
      app: :tablex,
      version: "0.2.0-alpha.4",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      {:nimble_parsec, "~> 1.3"},
      {:formular, "~> 0.4.1"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ucwidth, "~> 0.2"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ~w[
        README.md
        guides/nested_fields.md
        guides/informative_row.md
        guides/code_execution.md
        ],
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

      table.tablex.horizontal th {
        border-bottom: double;
        font-weight: bold;
      }

      table.tablex th .stub-type {
        display: block;
        font-style: italic;
        font-weight: normal;
        color: var(--tablex-stub-type-color);
      }

      table.tablex td.input + td.output {
        border-left: double;
      }

      table.tablex td.rule-number + td.output {
        border-left: double;
      }

      table.tablex th.input + th.output {
        border-left: double;
      }

      table.tablex th.hit-policy {
        border-right: double;
      }

      table.tablex td.rule-number {
        color: var(--tablex-rule-number-color);
        border-right: double;
        text-align: center;
      }

      table.tablex.vertical tbody {
        border-top: double;
      }

      table.tablex.vertical tfoot {
        border-top: double;
      }

      table.tablex.vertical th.output {
        border-right: double;
      }

      table.tablex.vertical th.input {
        border-right: double;
      }

      table.tablex.vertical tfoot {
        background-color: #EEE;
      }

      table.tablex.vertical td[colspan] {
        text-align: center;
      }

      table.tablex.vertical tbody th {
        text-align: left;
      }

      table.tablex.vertical tfoot th {
        text-align: left;
      }

      .tbx-exp-true {
        font-weight: bold;
      }

      .tbx-exp-false {
        font-weight: normal;
        font-style: italic;
      }

      .tbx-exp-number {
        color: var(--tablex-exp-number-color);
      }

      .tbx-exp-string {
        color: var(--tablex-exp-string-color);
      }

      .tbx-exp-any {
        color: var(--tablex-exp-any-color);
      }

      .tbx-exp-list-sep {
        color: var(--tablex-exp-list-sep-color);
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

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end

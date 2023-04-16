defmodule Tablex.Parser do
  @moduledoc """
  Parser is responsible for parsing the table from text to a Tablex.Table struct.

  ## Hit Policies

  Currently the following hit policies are supported:

  - "F" for `:first_hit`
  - "C" for `:collect`
  - "M" for `:merge`
  - "R" for `:reverse_merge`
  """
  alias Tablex.Table

  require Logger

  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Variable
  import Tablex.Parser.InformativeRow
  import Tablex.Parser.Rule

  @hit_policies [
    first_hit: "F",
    collect: "C",
    merge: "M",
    reverse_merge: "R"
  ]

  collect_hit_policy =
    string("C")
    |> map({__MODULE__, :to_policy, []})
    |> unwrap_and_tag(:hit_policy)

  regular_hit_policy =
    choice([
      string("F"),
      string("M"),
      string("R")
    ])
    |> map({__MODULE__, :to_policy, []})
    |> unwrap_and_tag(:hit_policy)

  @doc false
  for {policy, text} <- @hit_policies do
    def to_policy(unquote(text)), do: unquote(policy)
  end

  input_field =
    variable()
    |> space()
    |> unwrap_and_tag(:input)

  io_sperator = string("||") |> ignore()

  output_field =
    variable()
    |> optional_space()
    |> unwrap_and_tag(:output)

  table =
    choice([
      collect_hit_policy
      |> space()
      |> times(input_field, min: 0)
      |> label("`C` hit policy and optional input fields"),
      regular_hit_policy
      |> space()
      |> times(input_field, min: 1)
      |> label("input definitions")
    ])
    |> label("table header")
    |> concat(io_sperator)
    |> concat(space())
    |> times(output_field, min: 1)
    |> newline()
    |> concat(informative_row() |> newline() |> unwrap_and_tag(:info) |> optional())
    |> rules()

  defparsec(:table, table, debug: false)

  @doc """
  Parse a string into a table struct.

  ## Returns

  `%Tablex.Table{...}` if succeeds, other wise `{:error, {:invalid, reason, rest}}`
  """
  @spec parse(String.t(), []) :: Table.t() | {:error, {:invalid, String.t(), String.t()}}
  def parse(content, _opts) do
    case table(content) do
      {:ok, table, "", _context, _, _} ->
        Table.new(table)

      {:error, reason, rest, _context, {line, _}, offset} ->
        print_error(reason, line, offset, content)
        {:error, {:invalid, reason, rest}}
    end
  end

  defp print_error(reason, line, offset, content) do
    Logger.critical("""
    Error parsing decision table [L#{line} C#{offset}]:

    #{String.split(content, "\n") |> Enum.at(line - 1)}
    #{String.duplicate(" ", offset)}^ #{reason}.
    """)
  end

  @doc """
  Raising version of `parse/2`.
  """
  @spec parse(String.t(), []) :: Table.t()
  def parse!(text, opts) do
    case parse(text, opts) do
      %Table{} = t ->
        t

      {:error, _} ->
        raise "Invalid rule."
    end
  end
end

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

  use Tablex.Parser.Expression.List

  require Logger

  import NimbleParsec
  import Tablex.Parser.HorizontalTable
  import Tablex.Parser.VerticalTable

  @type parse_error() ::
          {:error,
           {:tablex_parse_error, {location(), reason :: :invalid | term(), rest :: binary()}}}
  @type location() :: [{:line, non_neg_integer()} | {:column, non_neg_integer()}]

  table =
    choice([
      h_table() |> tag(:horizontal),
      v_table() |> tag(:vertical)
    ])

  defparsec(:table, table, debug: false)
  defparsec(:expr, Tablex.Parser.Expression.expression())

  @doc """
  Parse a string into a table struct.

  ## Returns

  `%Tablex.Table{...}` if succeeds, other wise `{:error, {:tablex_parse_error, location, reason, rest}}`
  """
  @spec parse(String.t(), []) :: Table.t() | parse_error()
  def parse(content, _opts) do
    case table(content) do
      {:ok, table, "", _context, _, _} ->
        Table.new(table)

      {:ok, _table, rest, _context, {line, _offset}, _column} ->
        print_error("unexpected input", line, 0, content)
        location = [line: line, column: 0]
        {:error, {:tablex_parse_error, {location, :invalid, rest}}}

      {:error, reason, rest, _context, {line, _}, column} ->
        print_error(reason, line, column, content)
        location = [line: line, column: column]
        {:error, {:tablex_parse_error, {location, reason, rest}}}
    end
  end

  defp print_error(reason, line, column, content) do
    Logger.critical("""
    Error parsing decision table [L#{line} C#{column}]:

    #{String.split(content, "\n") |> Enum.at(line)}
    #{String.duplicate(" ", column)}^ #{reason}.
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

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
  import Tablex.Parser.HorizontalTable
  import Tablex.Parser.VerticalTable

  table =
    choice([
      h_table() |> tag(:horizontal),
      v_table() |> tag(:vertical)
    ])

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

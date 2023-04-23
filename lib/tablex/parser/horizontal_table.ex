defmodule Tablex.Parser.HorizontalTable do
  @moduledoc false

  alias Tablex.HitPolicy

  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Variable
  import Tablex.Parser.InformativeRow
  import Tablex.Parser.Rule

  def h_table do
    choice([
      collect_hit_policy()
      |> space()
      |> times(input_field(), min: 0)
      |> label("`C` hit policy and optional input fields"),
      regular_hit_policy()
      |> space()
      |> times(input_field(), min: 1)
      |> label("input definitions")
    ])
    |> label("table header")
    |> concat(io_sperator())
    |> concat(space())
    |> times(output_field(), min: 1)
    |> newline()
    |> concat(informative_row() |> newline() |> unwrap_and_tag(:info) |> optional())
    |> rules()
  end

  # Only with collect hit policy, there can be zero input stubs.
  def collect_hit_policy do
    string("C")
    |> map({HitPolicy, :to_policy, []})
    |> unwrap_and_tag(:hit_policy)
  end

  def regular_hit_policy do
    choice([
      string("F"),
      string("M"),
      string("R")
    ])
    |> map({HitPolicy, :to_policy, []})
    |> unwrap_and_tag(:hit_policy)
  end

  def input_field do
    variable()
    |> space()
    |> unwrap_and_tag(:input)
  end

  def io_sperator, do: string("||") |> ignore()

  def output_field do
    variable()
    |> optional_space()
    |> unwrap_and_tag(:output)
  end
end

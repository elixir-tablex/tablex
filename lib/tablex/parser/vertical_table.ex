defmodule Tablex.Parser.VerticalTable do
  @moduledoc false

  alias Tablex.HitPolicy

  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Variable
  import Tablex.Parser.Expression

  def v_table do
    hr()
    |> concat(first_line())
    |> times(input_line(), min: 0)
    |> concat(hr())
    |> times(output_line(), min: 1)
  end

  def hr do
    ascii_string([?=], min: 4)
    |> optional_space()
    |> newline()
    |> ignore()
  end

  def first_line() do
    hit_policy()
    |> space()
    |> vertical_sep()
    |> rule_numbers()
    |> eol()
  end

  def hit_policy do
    choice([
      string("C"),
      string("F"),
      string("M"),
      string("R")
    ])
    |> map({HitPolicy, :to_policy, []})
    |> unwrap_and_tag(:hit_policy)
  end

  def rule_numbers(combinator) do
    combinator
    |> concat(rule_numbers())
  end

  def rule_numbers do
    times(
      concat(
        space(),
        integer(min: 1)
      ),
      min: 1
    )
    |> tag(:rule_numbers)
  end

  def input_line do
    input_field()
    |> vertical_sep()
    |> concat(conditions())
    |> eol()
    |> tag(:input)
  end

  def conditions do
    times(
      concat(
        space(),
        expression()
      ),
      min: 1
    )
  end

  def vertical_sep(combinator \\ empty()) do
    combinator
    |> concat(string("||") |> ignore())
  end

  def output_line do
    output_field()
    |> vertical_sep()
    |> concat(output_values())
    |> eol()
    |> tag(:output)
  end

  def input_field do
    variable()
    |> optional_space()
  end

  def output_field do
    variable()
    |> optional_space()
  end

  def output_values do
    times(
      concat(
        space(),
        expression()
      ),
      min: 1
    )
  end
end

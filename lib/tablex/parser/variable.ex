defmodule Tablex.Parser.Variable do
  import NimbleParsec
  import Tablex.Parser.Quoted
  import Tablex.Parser.Space

  def name do
    choice([
      ascii_char([?A..?z])
      |> times(ascii_char([?0..?9, ?_, ?-, ?A..?z]), min: 0)
      |> reduce({List, :to_string, []}),
      quoted_string()
    ])
  end

  def type_enum do
    choice([
      string("integer"),
      string("float"),
      string("number"),
      string("string"),
      string("date"),
      string("time"),
      string("datetime"),
      string("bool")
    ])
    |> map({String, :to_atom, []})
  end

  def type do
    string(" (")
    |> ignore()
    |> concat(optional_space())
    |> concat(type_enum())
    |> concat(
      string(",")
      |> utf8_string([not: ?)], min: 1)
      |> optional()
      |> ignore()
    )
    |> ignore(string(")"))
  end

  def variable do
    concat(
      name(),
      optional(type())
    )
    |> reduce({:trans_var, []})
  end

  @doc false
  def trans_var([name]) do
    trans_var([name, :undefined])
  end

  def trans_var([name, type]) do
    {to_name(name), type}
  end

  defp to_name(name),
    do: {
      name
      |> String.replace(["-", " "], "_")
      |> Macro.underscore()
      |> String.replace(~r/_+/, "_")
      |> String.to_atom(),
      name
    }
end

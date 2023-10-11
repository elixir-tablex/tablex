defmodule Tablex.Parser.Variable do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Expression.QuotedString
  import Tablex.Parser.Space

  def variable do
    concat(
      name() |> lookahead(eow()) |> reduce({__MODULE__, :trans_name, []}),
      optional(concat(optional_space(), type()))
    )
    |> reduce({__MODULE__, :trans_var, []})
  end

  def name do
    choice([
      varname(),
      quoted_string()
    ])
  end

  def varname do
    ascii_varname()
    |> times(
      string(".")
      |> concat(ascii_varname()),
      min: 0
    )
  end

  def ascii_varname do
    ascii_char([?A..?z])
    |> times(ascii_char([?0..?9, ?_, ?-, ?A..?z]), min: 0)
    |> reduce({List, :to_string, []})
  end

  @doc false
  def trans_name(list) do
    List.to_string(list)
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
    string("(")
    |> ignore()
    |> concat(optional_space())
    |> concat(type_enum())
    |> concat(
      string(",")
      |> ignore()
      |> optional_space()
      |> utf8_string([not: ?)], min: 1)
      |> optional()
    )
    |> ignore(string(")"))
  end

  @doc false
  def trans_var([label]) do
    trans_var([label, :undefined])
  end

  def trans_var([label, type]) do
    trans_var([label, type, nil])
  end

  def trans_var([label, type, desc]) do
    {name, path} = to_name_path(label)

    %Tablex.Variable{
      name: name,
      label: label,
      type: type,
      desc: desc,
      path: path
    }
  end

  defp to_name_path(label) do
    [name | path] =
      label
      |> String.split(".", trim: true)
      |> Stream.map(fn t ->
        t
        |> String.trim()
        |> String.replace(["-", " "], "_")
        |> String.to_atom()
      end)
      |> Enum.reverse()

    {name, Enum.reverse(path)}
  end
end

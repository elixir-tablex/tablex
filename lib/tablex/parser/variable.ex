defmodule Tablex.Parser.Variable do
  @moduledoc """
  Parsisng variable name, type and/or description.

  The source should be in the following format:

      name (type, desc)

  where name can be a quoted string or a string containing
  no space.
  """

  @type t :: %__MODULE__{
          name: atom(),
          label: String.t(),
          desc: String.t(),
          type: :undefined | var_type(),
          path: [atom()]
        }

  @type var_type :: :integer | :float | :number | :string | :bool

  @enforce_keys [:name]

  defstruct [:name, :label, :desc, type: :undefined, path: []]

  import NimbleParsec
  import Tablex.Parser.Quoted
  import Tablex.Parser.Space

  def variable do
    concat(
      name() |> lookahead(eow()) |> reduce({:trans_name, []}),
      optional(type())
    )
    |> reduce({:trans_var, []})
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
    string(" (")
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

    %__MODULE__{
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
        |> Macro.underscore()
        |> String.replace(~r/_+/, "_")
        |> String.to_atom()
      end)
      |> Enum.reverse()

    {name, Enum.reverse(path)}
  end
end

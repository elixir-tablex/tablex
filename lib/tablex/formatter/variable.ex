defmodule Tablex.Formatter.Variable do
  alias Tablex.Variable

  def render_var_def(%Variable{} = var, true) do
    maybe_quoted(var.label)
  end

  def render_var_def(%Variable{} = var, false) do
    case var.type do
      :undefined ->
        maybe_quoted(var.label)

      type ->
        [maybe_quoted(var.label), " (", render_var_type(type), ")"]
        |> IO.iodata_to_binary()
    end
  end

  def maybe_quoted(str) do
    if String.contains?(str, " ") do
      inspect(str)
    else
      str
    end
  end

  def render_var_type(:undefined) do
    []
  end

  def render_var_type(type) do
    [type_to_string(type)]
  end

  def type_to_string(type), do: to_string(type)

  def render_var_desc(%Variable{type: :undefined}), do: "-"

  def render_var_desc(%Variable{type: type, desc: desc}) when not is_nil(desc),
    do: ["(", type_to_string(type), ", ", desc, ")"] |> IO.iodata_to_binary()

  def render_var_desc(%Variable{type: type}),
    do: ["(", type_to_string(type), ")"] |> IO.iodata_to_binary()
end

defmodule Tablex.Formatter.Value do
  @comparisons ~w[!= >= > <= <]a

  @doc """
  Render a value into inspectable text.
  """
  @spec render_value(any) :: String.t()
  def render_value([value]) do
    ["[", render_value(value), "]"] |> IO.iodata_to_binary()
  end

  def render_value([_ | _] = value) do
    Enum.map_join(value, ",", &render_value/1)
  end

  def render_value(:any), do: "-"
  def render_value(true), do: "yes"
  def render_value(false), do: "no"
  def render_value(n) when is_number(n), do: to_string(n)
  def render_value(nil), do: "null"
  def render_value(%Range{first: first, last: last}), do: "#{first}..#{last}"

  def render_value({:!=, n}), do: "!=#{n}"

  def render_value({comparison, n}) when comparison in @comparisons and is_number(n),
    do: "#{comparison}#{n}"

  def render_value(str) when is_binary(str) do
    maybe_quoted(str)
  end

  def render_value(value) do
    inspect(value)
  end

  defp maybe_quoted(str) do
    if String.contains?(str, " ") do
      inspect(str)
    else
      str
    end
  end
end

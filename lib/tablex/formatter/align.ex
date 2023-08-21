defmodule Tablex.Formatter.Align do
  def align_columns(lines) do
    lines
    |> Stream.zip()
    |> Stream.map(fn columns ->
      columns = Tuple.to_list(columns)

      max_len =
        columns
        |> Stream.map(&string_width/1)
        |> Enum.max()

      columns
      |> Enum.map(&pad_trailing(&1, max_len))
    end)
    |> Stream.zip()
    |> Enum.map(fn line ->
      line
      |> Tuple.to_list()
      |> Enum.join(" ")
      |> String.trim_trailing()
    end)
  end

  defp string_width("" <> str),
    do: Ucwidth.width(str)

  defp pad_trailing(str, max_len) do
    case string_width(str) do
      n when n > max_len -> str
      n -> str <> String.duplicate(" ", max_len - n)
    end
  end
end

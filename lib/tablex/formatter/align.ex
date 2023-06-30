defmodule Tablex.Formatter.Align do
  def align_columns(lines) do
    lines
    |> Stream.zip()
    |> Stream.map(fn columns ->
      columns = Tuple.to_list(columns)

      max_len =
        columns
        |> Stream.map(&String.length/1)
        |> Enum.max()

      columns
      |> Enum.map(&String.pad_trailing(&1, max_len))
    end)
    |> Stream.zip()
    |> Enum.map(fn line ->
      line
      |> Tuple.to_list()
      |> Enum.join(" ")
      |> String.trim_trailing()
    end)
  end
end

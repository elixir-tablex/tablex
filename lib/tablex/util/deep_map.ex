defmodule Tablex.Util.DeepMap do
  @doc """
  Flatten a map recursively.
  """

  def flatten(outputs) do
    Enum.reduce(outputs, %{}, fn {path, v}, acc ->
      acc |> put_recursively(path, v)
    end)
  end

  defp put_recursively(%{} = acc, [path], value) do
    Map.put(acc, path, value)
  end

  defp put_recursively(%{} = acc, [head | rest], value) do
    v = put_recursively(%{}, rest, value)
    Map.update(acc, head, v, &Map.merge(&1, v))
  end
end

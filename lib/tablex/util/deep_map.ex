defmodule Tablex.Util.DeepMap do
  @doc """
  Flatten a map recursively.
  """

  def flatten(outputs) do
    Enum.reduce(outputs, %{}, fn {path, v}, acc ->
      acc |> put_recursively(path, v)
    end)
  end

  defp put_recursively(_, [], value) do
    value
  end

  defp put_recursively(%{} = acc, [head | rest], value) do
    v = put_recursively(%{}, rest, value)

    Map.update(
      acc,
      head,
      v,
      &Map.merge(&1, v, fn
        _, %{} = v1, %{} = v2 ->
          Map.merge(v1, v2)

        _, _, v2 ->
          v2
      end)
    )
  end
end

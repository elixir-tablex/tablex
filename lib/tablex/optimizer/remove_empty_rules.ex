defmodule Tablex.Optimizer.RemoveEmptyRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing rules wihtout sense
  which have all `any` values in the output.
  """

  alias Tablex.Table

  def optimize(%Table{} = table) do
    remove_no_value_rules(table)
  end

  defp remove_no_value_rules(%Table{} = table),
    do:
      Map.update!(table, :rules, fn rules ->
        rules |> Enum.reject(&no_value?(&1))
      end)

  defp no_value?([_id, _, {:output, output}]),
    do: Enum.all?(output, &(&1 == :any))
end

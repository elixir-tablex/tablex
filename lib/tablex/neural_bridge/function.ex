defmodule NeuralBridge.Function do
  @moduledoc false
  require Decimal
  require Logger

  defstruct variable_name: nil,
            function_name: nil,
            arguments: [],
            # The module that implements Retex.FunctionBehaviour
            functions_mod: nil

  def new(variable_name, function_name, args)
      when is_binary(variable_name) and is_binary(function_name) and is_list(args) do
    %__MODULE__{variable_name: variable_name, function_name: function_name, arguments: args}
  end

  def call(name, args, bindings, function_mod) when is_binary(name) when is_list(args) do
    args = Enum.map(args, fn variable -> Map.get(bindings, variable, variable) end)

    try do
      post_process(function_mod.call(name, pre_process_args(args)))
    rescue
      e ->
        message =
          "Error while executing #{name} with args #{inspect(args)}" <> Exception.message(e)

        Logger.error(message)

        "ERROR"
    end
  end

  def pre_process_args(args) do
    Enum.map(args, fn arg -> arg end)
  end

  defp post_process(value) do
    cond do
      Decimal.is_decimal(value) ->
        Decimal.to_float(value)

      true ->
        value
    end
  end
end

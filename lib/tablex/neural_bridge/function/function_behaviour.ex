defmodule NeuralBridge.FunctionBehaviour do
  @callback call(function_name :: String, arguments :: list(any())) :: any()
end

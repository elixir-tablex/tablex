defmodule NeuralBridge.DefinedFunctions do
  @behaviour NeuralBridge.FunctionBehaviour
  alias Decimal
  require Decimal

  @impl NeuralBridge.FunctionBehaviour
  def call("div", [a, b]) do
    Decimal.div(Decimal.new(a), Decimal.new(b))
  end

  def call("compare", [a, b]) do
    Decimal.compare(Decimal.new(a), Decimal.new(b))
  end

  def call("equal", [a, b]) do
    Decimal.equal?(Decimal.new(a), Decimal.new(b))
  end

  def call("add", [a, b]) do
    Decimal.add(Decimal.new(a), Decimal.new(b))
  end

  def call("div_int", [a, b]) do
    Decimal.div_int(Decimal.new(a), Decimal.new(b))
  end

  def call("div_rem", [a, b]) do
    Decimal.div_int(Decimal.new(a), Decimal.new(b))
  end

  def call("is_decimal", [a]) do
    Decimal.is_decimal(a)
  end

  def call("min", [a, b]) do
    min(a, b)
  end

  def call("max", [a, b]) do
    max(a, b)
  end

  def call("mult", [a, b]) do
    Decimal.mult(Decimal.new("#{a}"), Decimal.new("#{b}"))
  end

  def call("round", [a]) do
    Decimal.round(Decimal.new(a))
  end

  def call("round", [num, places]) when is_binary(num) do
    Decimal.round(Decimal.new(num), places)
  end

  def call("round", [num, places]) when is_float(num) do
    Decimal.round(Decimal.from_float(num), places)
  end

  def call("round", [num, places, mode]) when is_float(num) do
    Decimal.round(Decimal.from_float(num), places, String.to_existing_atom(mode))
  end

  def call("round", [num, places, mode]) when is_binary(num) do
    Decimal.round(Decimal.new(num), places, String.to_existing_atom(mode))
  end

  def call("to_string", [num, mode]) when is_binary(num) do
    Decimal.to_string(Decimal.new(num), String.to_existing_atom(mode))
  end

  def call("to_string", [num, mode]) when is_float(num) do
    Decimal.to_string(Decimal.from_float(num), String.to_existing_atom(mode))
  end

  def call("to_string", [num]) when is_float(num) do
    Decimal.to_string(Decimal.from_float(num))
  end

  def call("abs", [a]) when is_binary(a) do
    Decimal.abs(Decimal.new(a))
  end

  def call("abs", [a]) when is_float(a) do
    Decimal.abs(Decimal.from_float(a))
  end

  def call("abs", [a]) when is_number(a) do
    Decimal.abs(Decimal.new("#{a}"))
  end

  def call(name, args) do
    raise "Undefined function #{name} with args #{inspect(args)}"
  end
end

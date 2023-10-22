defmodule Tablex.Decider do
  def decide(table, args, opts) do
    impl().decide(table, args, opts)
  end

  defp impl() do
    Application.get_env(:tablex, :decider, Tablex.Decider.Naive)
  end
end

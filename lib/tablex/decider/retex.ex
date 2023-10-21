defmodule Tablex.Decider.Retex do
  @moduledoc """
  Decision engine module responsible for applying a set of rules to input data
  and returning the output according to the hit policy.
  """

  alias Tablex.Table
  import Tablex.Rules, only: [match_expect?: 2]

  @type options :: []

  @doc """
  Run the decision process on the given table, arguments, and options.
  """
  @spec decide(Table.t(), keyword(), options()) :: map() | {:error, :hit_policy_not_implemented}
  def decide(table, args, opts \\ [])

  def decide(%Table{hit_policy: :first_hit} = table, args, opts) do
  end

  def decide(%Table{hit_policy: :collect} = table, args, opts) do
  end

  def decide(%Table{hit_policy: :merge} = table, args, opts) do
  end

  def decide(%Table{hit_policy: :reverse_merge} = table, args, _opts) do
  end

  def decide(%Table{}, _, _) do
    {:error, :hit_policy_not_implemented}
  end

  def decide({:error, _} = err, _, _) do
    err
  end
end

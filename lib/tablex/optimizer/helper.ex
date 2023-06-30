defmodule Tablex.Optimizer.Helper do
  @type order() :: :h2l | :l2h
  @type rule :: Tablex.Table.rule()

  @doc """
  Order a list of table rules by priority, high to low.
  """
  def order_by_priority_high_to_lower(rules, :reverse_merge),
    do: Enum.reverse(rules)

  def order_by_priority_high_to_lower(rules, _),
    do: rules

  @doc """
  Order an already sorted, list of rules by hit policy.
  """
  @spec order_by_hit_policy([rule()], current_order :: order(), Tablex.HitPolicy.t()) :: [rule()]
  def order_by_hit_policy(rules, :h2l, :reverse_merge),
    do: rules |> Enum.reverse()

  def order_by_hit_policy(rules, :h2l, _),
    do: rules

  def order_by_hit_policy(rules, :l2h, :reverse_merge),
    do: rules

  def order_by_hit_policy(rules, :l2h, _),
    do: Enum.reverse(rules)

  @doc """
  Fix ids of rules.
  """
  @spec fix_ids([rule()]) :: [rule()]
  def fix_ids(rules) do
    Stream.with_index(rules, 1)
    |> Enum.map(fn {[_ | tail], id} -> [id | tail] end)
  end
end

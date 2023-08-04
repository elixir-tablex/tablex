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
  @spec order_by_hit_policy([rule()], current_order :: order(), Tablex.HitPolicy.hit_policy()) ::
          [rule()]
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

  @doc """
  Check if a input condition covers by another.
  """
  @spec covers?(covering :: any(), target :: any()) :: boolean()
  def covers?(input, input) do
    true
  end

  def covers?(existing_input, input) do
    Stream.zip(existing_input, input)
    |> Enum.all?(fn {existing, new} -> stub_covers?(existing, new) end)
  end

  def stub_covers?(:any, _), do: true
  def stub_covers?(same, same), do: true

  def stub_covers?({:>, n}, {cmp, m})
      when is_number(n) and is_number(m) and n < m and cmp in [:>, :>=],
      do: true

  def stub_covers?({:>=, n}, {cmp, m})
      when is_number(n) and is_number(m) and n <= m and cmp in [:>=, :>],
      do: true

  def stub_covers?({:<, n}, {cmp, m})
      when is_number(n) and is_number(m) and n > m and cmp in [:<, :<=],
      do: true

  def stub_covers?({:<=, n}, {cmp, m})
      when is_number(n) and is_number(m) and n >= m and cmp in [:<, :<=],
      do: true

  def stub_covers?(expr, list) when is_list(list),
    do: Enum.all?(list, &stub_covers?(expr, &1))

  def stub_covers?(list, item) when is_list(list),
    do: Enum.any?(list, &stub_covers?(&1, item))

  def stub_covers?(_, _),
    do: false

  @doc """
  Remove all already-existing stubs in an output.

  ## Example

    iex> conflict_free_output([1, 2, 3], [2, 4, 6])
    [:any, :any, :any]

    iex> conflict_free_output([1, 2, 3], [2, :any, 6])
    [:any, 2, :any]
  """
  def conflict_free_output(output, existing_output) do
    Stream.zip(output, existing_output)
    |> Enum.map(fn
      {stub, :any} -> stub
      _ -> :any
    end)
  end

  @doc """
  Check if an output is meaningful. A meaningful output is one that
  does not contain all :any elements.
  """
  def meaningful_output?(output) do
    output |> Enum.any?(&(&1 != :any))
  end
end

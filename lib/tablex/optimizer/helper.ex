defmodule Tablex.Optimizer.Helper do
  @type order() :: :h2l | :l2h
  @type rule :: Tablex.Table.rule()

  @doc """
  Order a list of table rules by priority, high to low.
  """
  def order_by_priority_high_to_lower(rules, hp),
    do: order_by_priority(rules, :h2l, hp)

  @doc """
  Order an already sorted, list of rules by hit policy.
  """
  @spec order_by_priority([rule()], current_order :: order(), Tablex.HitPolicy.hit_policy()) ::
          [rule()]
  def order_by_priority(rules, :h2l, :reverse_merge),
    do: rules |> Enum.sort_by(fn_reverse_orders())

  def order_by_priority(rules, :h2l, _),
    do: rules |> Enum.sort_by(fn_keep_orders())

  def order_by_priority(rules, :l2h, :reverse_merge),
    do: rules |> Enum.sort_by(fn_keep_orders())

  def order_by_priority(rules, :l2h, _),
    do: rules |> Enum.sort_by(fn_reverse_orders())

  defp fn_keep_orders, do: fn [n | _] -> n end
  defp fn_reverse_orders, do: fn [n | _] -> -n end

  @doc """
  Sort the rules according to a hit policy.
  """
  def sort_rules(rules, hit_policy) do
    sorting =
      case hit_policy do
        :reverse_merge -> :l2h
        _ -> :h2l
      end

    order_by_priority(rules, sorting, hit_policy)
  end

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
  @spec cover_input?(covering :: any(), target :: any()) :: boolean()
  def cover_input?(input, input) do
    true
  end

  def cover_input?(existing_input, input) do
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

  def cover_output?(output, output) do
    true
  end

  def cover_output?(high_output, low_output) do
    Stream.zip(high_output, low_output)
    |> Enum.all?(fn
      {:any, :any} ->
        true

      {:any, _} ->
        false

      _ ->
        true
    end)
  end

  @doc """
  Merge two outputs. Stub value with higher priority wins.

  ## Example

  iex > merge_outputs([1, 2, 3], [2, 4, 6])
  [1, 2, 3]

  iex > merge_outputs([:any, 2, :any], [2, :any, 6])
  [2, 2, 6]
  """
  def merge_outputs(high_output, low_output) do
    Stream.zip(high_output, low_output)
    |> Enum.map(fn
      {:any, stub} ->
        stub

      {stub, _} ->
        stub
    end)
  end

  @doc """
  Check if an output is meaningful. A meaningful output is one that
  does not contain all :any elements.
  """

  def meaningful_output?(output) do
    output |> Enum.any?(&(&1 != :any))
  end

  def exclusive?([_, {:input, input1} | _], [_, {:input, input2} | _]) do
    exclusive?(input1, input2)
  end

  def exclusive?(input1, input2) do
    Stream.zip(input1, input2)
    |> Enum.any?(fn
      # `a` and `b` are both specified (not `:any`) and they are
      # different, which means these two rules will never be both
      # hit by the same context.
      {a, b} when a != b and a != :any and b != :any ->
        true

      _ ->
        false
    end)
  end
end

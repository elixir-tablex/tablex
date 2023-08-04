defmodule Tablex.Util.ListBreaker do
  def flatten_list([]) do
    [[]]
  end

  def flatten_list([head | tail]) do
    for i <- List.wrap(head),
        j <- flatten_list(tail),
        do: [i | j]
  end
end

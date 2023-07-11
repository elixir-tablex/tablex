defmodule Tablex.Formatter.HitPolicy do
  def render_hit_policy(%{hit_policy: :first_hit}), do: "F"
  def render_hit_policy(%{hit_policy: :merge}), do: "M"
  def render_hit_policy(%{hit_policy: :collect}), do: "C"
  def render_hit_policy(%{hit_policy: :reverse_merge}), do: "R"
end

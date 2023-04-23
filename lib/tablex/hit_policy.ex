defmodule Tablex.HitPolicy do
  @moduledoc """
  This module defines hit policies.
  """

  @type hit_policy :: :first_hit | :collect | :merge | :reverse_merge

  @hit_policies [
    first_hit: "F",
    collect: "C",
    merge: "M",
    reverse_merge: "R"
  ]

  @doc """
  Get all supported hit policies.
  """
  @spec hit_policies() :: [{hit_policy(), mark :: String.t()}]
  def hit_policies do
    @hit_policies
  end

  @doc """
  """
  @spec to_policy(String.t()) :: hit_policy() | nil
  for {policy, text} <- @hit_policies do
    def to_policy(unquote(text)), do: unquote(policy)
  end
end

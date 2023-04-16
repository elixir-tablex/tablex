defmodule Tablex.Variable do
  @type t :: %__MODULE__{
          name: atom(),
          label: String.t(),
          desc: String.t(),
          type: :undefined | var_type(),
          path: [atom()]
        }

  @type var_type :: :integer | :float | :number | :string | :bool

  @enforce_keys [:name]

  defstruct [:name, :label, :desc, type: :undefined, path: []]
end

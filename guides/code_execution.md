# Code Execution

We can execute code in rules. This may be useful in the following scenarios:

- The output of a rule is not literal but should be calculated based on the input.
- One input field's value is based on another.

Currently (v0.1.0), we only support execution in output fields.

> ### Security Warning {: .error}
> Use this feature with extreme caution! Never trust inputs from users.

## Syntax

Code is wrapped in a "\`" pair, e.g.

    iex> table = Tablex.new("""
    ...>   F x   || abs
    ...>   1 >=0 || `x`
    ...>   2 <0  || `-x`
    ...>   """)
    ...>
    ...> Tablex.decide(table, x: -42)
    %{abs: 42}

## Restriction

The code is in raw Elixir format but not all syntax tokens are allowed to use. It follows the [default restriction](https://hexdocs.pm/formular/Formular.html#module-kernel-functions-and-macros) of [formular][].

For example, the following code is not allowed:

`MyApp.foo()` because it is not supported to invoke "." operation.

## Variables

We can refer to arbitrary variable names as long as are provided in the binding argument of `Tablex.decide/2` or `Tablex/decide/3`. For example:

    iex> table = Tablex.new("""
    ...>   M day_of_week || "Go to Library"  Volunteer  Blogging
    ...>   1 1           || T                -          -
    ...>   2 2           || F                T          -
    ...>   3 -           || F                F          `week_of_month == 4`
    ...>   """)
    ...>
    ...> Tablex.decide(table, day_of_week: 1, week_of_month: 4)
    %{go_to_library: true, volunteer: false, blogging: true}

Note that `week_of_month` is not an input field but a bound variable on execution.

## Functions

Functions are supported through [formular][]'s [custom function](https://hexdocs.pm/formular/Formular.html#module-custom-functions).

Example:

    iex> defmodule MyFib do
    ...>   @table Tablex.new("""
    ...>     F x   || fib
    ...>     1 0   || 0
    ...>     2 1   || 1
    ...>     3 >=2 || `fib(x - 1) + fib(x - 2)`
    ...>     """)
    ...>
    ...>   def fib(x) when is_integer(x) and x >= 0 do
    ...>     %{fib: y} = Tablex.decide(@table, [x: x], context: __MODULE__)
    ...>     y
    ...>   end
    ...> end
    ...>
    ...> MyFib.fib(5)
    5

[Formular]: https://github.com/qhwa/formular

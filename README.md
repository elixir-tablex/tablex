# Tablex - Decision Tables in Elixir Code

Tablex is an implementation of the [Decision Table][] in Elixir. Its goal is to
make maitaining domain rules easy.

## Quick demo

Let's assume we decide what to do everyday based on day of week and the weather,
as the following table indicates:

<table class="tablex horizontal"><colgroup> <col span="1" class="rule-number"> <col span="2" class="input"> <col span="1" class="output"> </colgroup> <thead><tr><th class="hit-policy hit-policy-F"></th><th class="input">Day (string)</th><th class="input">Weather (string)</th><th class="output">Activity</th></tr></thead><tbody><tr><td class="rule-number">1</td><td rowspan="2" class="input">Monday, Tuesday, Wednesday, Thursday</td><td class="input">rainy</td><td class="output">read</td></tr><tr><td class="rule-number">2</td><td class="input">-</td><td class="output">read, walk</td></tr><tr><td class="rule-number">3</td><td rowspan="2" class="input">Friday</td><td class="input">sunny</td><td class="output">soccer</td></tr><tr><td class="rule-number">4</td><td class="input">-</td><td class="output">swim</td></tr><tr><td class="rule-number">5</td><td class="input">Saturday</td><td class="input">-</td><td class="output">watch movie, games</td></tr><tr><td class="rule-number">6</td><td class="input">Sunday</td><td class="input">-</td><td class="output">null</td></tr></tbody></table>

We can use a similar tabular form of the code in an Elixir program:

``` elixir
...> plans = Tablex.new("""
...> F   Day (string)                         Weather (string) || Activity
...> 1   Monday,Tuesday,Wednesday,Thursday    rainy            || read
...> 2   Monday,Tuesday,Wednesday,Thursday    -                || read,walk
...> 3   Friday                               sunny            || soccer
...> 4   Friday                               -                || swim
...> 5   Saturday                             -                || "watch movie",games
...> 6   Sunday                               -                || null
...> """)
...> 
...> Tablex.decide(plans, day: "Monday")
%{activity: ["read", "walk"]}
...> 
...> Tablex.decide(plans, day: "Friday", weather: "sunny")
%{activity: "soccer"}
...> 
...> Tablex.decide(plans, day: "Sunday")
%{activity: nil}
```

The above code demonstrates how we can determine what to do based on a set of rules
which are represented in a decision table on day and weather condition.

Inside the table, we defined the decision logic with:

1. An indicator of hit policy, `F` in this case meaning the first rule matched will be applied. See [`Hit Policies` section](#hit-policies) for more information.
2. Two input stubs, `day` and `weather` which are both strings. See [`Input Stubs` section](#input-stubs)
3. An output stub, `activity` in this case. See [`Output Stubs` section](#output-stubs)
4. Six rules which take inputs and determine the acitivity output. See [`Rules` section](#rules)
5. A friendly expression in each cell of the rules. See [`Expression` section](#expression)

## Input Stubs

Inputs can be defined with a set of `name (type[, description])` pairs. For example:

- `Age (integer)` defines an input field whose name is "age" and type is integer.
- `DOB (date, date of birth)` defines a date input field with a description label.

#### Name

Names can contain spaces in them if they are quoted. The following names are valid:

- `year_month_day`
- `yearMonthDay`
- `"year month day"`

They will all be converted to `year_month_day`.

#### Type

Currently the following types are supported:

- integer
- float
- number
- string
- bool

When types are specified, the input value shall be of the same type as specified.

## Output Stubs

Output stubs are defined as `name (type[, description])` where

- name can be a string which will be converted to an underscored atom;
- type can be either of the supported types (the same as inputs, see above section);
- description is optional and is currently ignored.

## Rules

After output stub definitions, each of the following rows defines a rule entry, with the format:

```
rule_number input_exp_1 input_exp_2 ... input_exp_m || output_exp_1 output_exp_2 ... output_exp_n
```

Rule number is primarily used for ordering. The rule with the lowest rule number has the highest priority.
Input expressions and output expressions are separated by "||".


## Expression

Currently only these types are supported:

- literal numeric value: integer and float (without scientific notation)
- literal quoted string in `"`
- boolean
- comparation: `>`, `>=`, `<`, `<=`
- range, e.g. `5..10`
- nil ("null")
- list of numeric, string, range, bool, nil or comparation; can be mixed
- any ("-")

The following types of expressions are planned:

- date
- time
- datetime
- function

## Hit policies

There are several hit policies to indicate how matched rules are applied.

- `F (First matched)` - the first matched rule will be applied.
- `C (Collect)` - all matched rules will be collected into result list.
- `M (Merge)` - all matched rules will be reduced (merged) into a single return entry, until there's no `-` in the output.
- `R (Reverse Merge)` - similar to `merge` but in a reversed order.

Examples:

#### First Hit

``` elixir
iex> table = Tablex.new("""
...> F   Age (integer)  || f (float)
...> 1   > 60           || 3.0
...> 2   50..60         || 2.5
...> 3   31..49         || 2.0
...> 4   15..18,20..30  || 1.0
...> 5   -              || 0
...> """
...> )
...> 
...> Tablex.decide(table, age: 30)
%{f: 1.0}
iex> Tablex.decide(table, age: 55)
%{f: 2.5}
iex> Tablex.decide(table, age: 22)
%{f: 1.0}
iex> Tablex.decide(table, age: 17)
%{f: 1.0}
iex> Tablex.decide(table, age: 1)
%{f: 0}
```

``` elixir
iex> table = Tablex.new("""
...> F   Age (integer)  "Years of Service"  || Holidays (integer)
...> 1   >=60           -                   || 3
...> 2   45..59         <30                 || 2
...> 3   -              >=30                || 22
...> 4   <18            -                   || 5
...> 5   -              -                   || 10
...> """
...> )
...>
...> Tablex.decide(table, age: 46, years_of_service: 30)
%{holidays: 22}
...>
iex> Tablex.decide(table, age: 17, years_of_service: 5)
%{holidays: 5}
...>
iex> Tablex.decide(table, age: 22)
%{holidays: 10}
```

#### Collect

Here's an example of `collect` hit policy:

``` elixir
iex> table = Tablex.new("""
...> C   OrderAmount    Membership       || Discount
...> 1   >=100          false            || "Free cupcake"
...> 2   >=100          true             || "Free icecream"
...> 3   -              true             || "20% OFF"
...> """
...> )
...>
iex> Tablex.decide(table, order_amount: 500, membership: false)
[%{discount: "Free cupcake"}]
...>
iex> Tablex.decide(table, order_amount: 500, membership: true)
[%{discount: "Free icecream"}, %{discount: "20% OFF"}]
...>
iex> Tablex.decide(table, order_amount: 80)
[]
```

Collect policy can work without any input:

``` elixir
iex> table = Tablex.new("""
...> C || Country         FeatureVersion
...> 1 || "New Zealand"   3
...> 2 || "Japan"         2
...> 3 || "Brazil"        2
...> """
...> )
...>
iex> Tablex.decide(table, [])
[%{country: "New Zealand", feature_version: 3}, %{country: "Japan", feature_version: 2}, %{country: "Brazil", feature_version: 2}]
```

#### Merge

Here's an example of `merge` hit policy:

``` elixir
iex> table = Tablex.new("""
...> M   Continent  Country  Province || Feature1 Feature2
...> 1   Asia       Thailand -        || true     true
...> 2   America    Canada   BC,ON    || -        true
...> 3   America    Canada   -        || true     false
...> 4   America    US       -        || false    false
...> 5   Europe     France   -        || true     -
...> 6   Europe     -        -        || false    true
...> """
...> )
...>
iex> Tablex.decide(table, continent: "Asia", country: "Thailand", province: "ACR")
%{feature1: true, feature2: true}
...>
iex> Tablex.decide(table, continent: "America", country: "Canada", province: "BC")
%{feature1: true, feature2: true}
...>
iex> Tablex.decide(table, continent: "America", country: "Canada", province: "QC")
%{feature1: true, feature2: false}
...>
iex> Tablex.decide(table, continent: "Europe", country: "France")
%{feature1: true, feature2: true}
```

The rules are applied until all the output fields are determined.

#### Reverse Merge

The `reverse_merge` works the same as `merge` but the rule ordering is reversed:

``` elixir
iex> table = Tablex.new("""
...> R   Continent  Country  Province || Feature1 Feature2
...> 1   Europe     -        -        || false    true
...> 2   Europe     France   -        || true     -
...> 3   America    US       -        || false    false
...> 4   America    Canada   -        || true     false
...> 5   America    Canada   BC,ON    || -        true
...> 6   Asia       Thailand -        || true     true
...> """
...> )
...>
iex> Tablex.decide(table, continent: "Asia", country: "Thailand", province: "ACR")
%{feature1: true, feature2: true}
...>
iex> Tablex.decide(table, continent: "America", country: "Canada", province: "BC")
%{feature1: true, feature2: true}
...>
iex> Tablex.decide(table, continent: "America", country: "Canada", province: "QC")
...>
%{feature1: true, feature2: false}
...>
iex> Tablex.decide(table, continent: "Europe", country: "France")
%{feature1: true, feature2: true}
```

## Generating Elixir Code

It is feasible to generate Elixir code from a table with `Tablex.CodeGenerate.generate/1`, as:

``` elixir
table = """
F CreditScore EmploymentStatus Debt-to-Income-Ratio || Action
1 700         employed         <0.43                || Approved
2 700         unemployed       -                    || "Further Review"
3 <=700       -                -                    || Denied
"""

Tablex.CodeGenerate.generate(table)
```

The code generated in the above example is:

``` elixir
case {credit_score, employment_status, debt_to_income_ratio} do
  {700, "employed", debt_to_income_ratio}
  when is_number(debt_to_income_ratio) and debt_to_income_ratio < 0.43 ->
    %{action: "Approved"}

  {700, "unemployed", _} ->
    %{action: "Further Review"}

  {credit_score, _, _} when is_number(credit_score) and credit_score <= 700 ->
    %{action: "Denied"}
end
```

## TODOs

* [x] nested input, e.g. `country.name` as an input stub name
* [x] nested output, e.g. `constraints.max_distance` as an output stub name
* [ ] support referring to other input entries in an input entry
* [ ] support functions in output entries
* [ ] support input validation
* [ ] support output validation
* [ ] support Date data type
* [ ] support Time data type
* [ ] support DateTime data type
* [ ] vertical tables
* [ ] rule code format

## Installation

The package can be installed by adding `tablex` to your list of dependencies in `mix.exs`:

``` elixir
def deps do
  [
    {:tablex, "~> 0.1.0"}
  ]
end
```

The docs can be found at <https://hexdocs.pm/tablex>.


## Credits

- Tablex is heavily inspired by [Decision Model and Notation (DMN)](https://en.wikipedia.org/wiki/dmn) and its [FEEL][] expression language.
- Tablex is built on top of the awesome [nimble_parsec][] library.

## License

Tablex is open sourced under [MIT license](https://opensource.org/license/mit/).

[Decision Table]: https://en.wikipedia.org/wiki/Decision_table
[DMN]: https://en.wikipedia.org/wiki/dmn
[FEEL]: https://kiegroup.github.io/dmn-feel-handbook/
[nimble_parsec]: https://hex.pm/packages/nimble_parsec

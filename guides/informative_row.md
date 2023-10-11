# Informative Row

The second row can be an informative row, to indicate the type and/or description of the variables.
This is useful when the input and output are getting too long.

For each stub, either an input or output, the format is the same, as:

```
(type[, description])
```

where type shall be one of the supported variable types, and description can be string,
or not specified (`-`).

## Examples

``` elixir
iex> table = Tablex.new("""
...>   F symptoms     test_results                              medical_history                  || treatment medication   follow_up
...>     (string)     (string, either NORMAL or ABNORMAL)       (string)                         || (string)  (string)     (integer, in weeks)
...>   1 fever,cough  NORMAL                                    "No Allergies"                   || Rest      OTC          2
...>   2 "Chest Pain" ABNORMAL                                  ECG,"Family Hx of Heart Disease" || Hospital  Prescription 1
...>   3 Headache     NORMAL                                    "Migraine Hx"                    || Rest      Prescription 3
...>   """)
...>
...> for %{name: name, type: type, desc: desc} <- table.inputs, do: {name, type, desc}
[
  {:symptoms, :string, nil},
  {:test_results, :string, "either NORMAL or ABNORMAL"},
  {:medical_history, :string, nil}
]
```

Descriptions are optional.

## Skipping Stubs

In case you want to skip some field(s), `"-"` can be used, as:

``` elixir
iex> table = Tablex.new("""
...>   F customer_segment   purchase_frequency    || campaign_type   discount   email_frequency
...>     -                  (integer, times/year) || -               -          -
...>   1 Loyal              >8                    || Personalized    "20%"      Monthly
...>   2 Occasional         2..8                  || Seasonal        "10%"      Quarterly
...>   3 Inactive           <2                    || Re-engagement   "15%"      Biannually
...>   """)
...>
...> for %{name: name, type: type, desc: desc} <- table.inputs, do: {name, type, desc}
[
  {:customer_segment, :undefined, nil},
  {:purchase_frequency, :integer, "times/year"}
]
...> Tablex.decide(table, customer_segment: "Inactive", purchase_frequency: 1)
%{campaign_type: "Re-engagement", discount: "15%", email_frequency: "Biannually"}
```

# Nested Fields

When working with nested data structures, Tablex allows either checking against deep structs or outputting values on a deep path inside a map.

## Path

Pathes can be defined with `.` separator. For instance, `path.to.data` which will match `%{path: %{to: data}}` when used in input stubs, or meandeeply merging `%{path: %{to: data}}` into the output when used in output stubs.

## Nested Input Fields

For example, we can decide whether to report an HTTP request based on it request method, request host and response status:

``` elixir
iex> table = Tablex.new("""
...>   F request.method request.host response.status || report
...>   1 GET            -            -               || F
...>   2 -              example.com  -               || F
...>   3 -              -            <400            || F
...>   4 -              -            -               || T
...>   """)
...> 
...> Tablex.decide(table, request: %{method: "POST", host: "myapp.com"}, response: %{status: 500})
%{report: true}
...> 
iex> Tablex.decide(table, request: %{method: "GET", host: "myapp.com"})
%{report: false}
...> 
iex> Tablex.decide(table, request: %{method: "POST", host: "example.com"})
%{report: false}
```

## Nested Output Fields

When data is nested in output stubs, it will be put in a deep path.

### Example

Following is an example of using nested output stubs in a table.

``` elixir
iex> table = Tablex.new("""
...>   M "Car Size" "Rental Duration"  "Miles Driven"    || price.base      price.extra_mileage_fee  price.insurance_fee
...>     -          (number, in days)  (number, per day) || (number, $/day) (number, $/mile)         (number, $/day)
...>   1 compact    <=3                <=100             || 50              0.25                     15
...>   2 mid_size   4..7               101..200          || 70              0.30                     -
...>   3 full_size  >7                 > 200             || 90              0.35                     25
...>   4 -          -                  -                 || -               -                        20
...>   """)
...>
...> Tablex.decide(
...>   table,
...>   car_size: "mid_size",
...>   rental_duration: 7,
...>   miles_driven: 101
...> )
%{price: %{base: 70, extra_mileage_fee: 0.3, insurance_fee: 20}}
```


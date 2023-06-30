a = %{a: 5}
b = %{b: 0}

ret =
  for ret when not is_nil(ret) <- [
        if(match?({_, %{b: %{b: 0}}}, {a, b}),
          do: %{div: "b.b is zero"}
        ),
        if(match?({_, %{b: %{b: b_b}}} when is_number(b_b) and b_b != 0, {a, b}),
          do: %{div: a.a / b.b}
        )
      ],
      do: ret

IO.inspect(ret)

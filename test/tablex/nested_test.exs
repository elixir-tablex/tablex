defmodule Tablex.NestedTest do
  use ExUnit.Case

  describe "Nested output definition" do
    test "works" do
      table =
        Tablex.new("""
        C || a.b  a.c
        1 || 1    2
        2 || 3    4
        """)

      Mox.expect(DeciderBehaviourMock, :decide, fn a, b, c ->
        Tablex.Decider.Naive.decide(a, b, c)
      end)

      assert Tablex.decide(table, []) == [
               %{a: %{b: 1, c: 2}},
               %{a: %{b: 3, c: 4}}
             ]
    end

    defmodule StructA do
      defstruct [:a]
    end

    defmodule StructB do
      defstruct [:b]
    end

    test "works with structs" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 -    || F
        """)

      Mox.expect(DeciderBehaviourMock, :decide, fn a, b, c ->
        Tablex.Decider.Naive.decide(a, b, c)
      end)

      assert %{hit: false} = Tablex.decide(table, %StructA{a: %StructB{b: 10}})

      Mox.expect(DeciderBehaviourMock, :decide, fn a, b, c ->
        Tablex.Decider.Naive.decide(a, b, c)
      end)

      assert %{hit: true} = Tablex.decide(table, %StructA{a: %StructB{b: 9}})
    end
  end

  describe "Nested input definition" do
    test "works" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 -    || F
        """)

      Mox.expect(DeciderBehaviourMock, :decide, fn a, b, c ->
        Tablex.Decider.Naive.decide(a, b, c)
      end)

      assert Tablex.decide(table, a: %{b: 10}) == %{hit: false}

      Mox.expect(DeciderBehaviourMock, :decide, fn a, b, c ->
        Tablex.Decider.Naive.decide(a, b, c)
      end)

      assert Tablex.decide(table, a: %{b: 9}) == %{hit: true}
    end
  end

  describe "Generated code" do
    test "contains recursive pattern matching" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 -    || F
        """)

      code = Tablex.CodeGenerate.generate(table)

      assert {%{hit: false}, _} = Code.eval_string(code, a: %{b: 10})
      assert {%{hit: true}, _} = Code.eval_string(code, a: %{b: 9})
    end

    test "works with more levels" do
      table =
        Tablex.new("""
        F a.b.c  || hit
        1 <10    || T
        2 -      || F
        """)

      code = Tablex.CodeGenerate.generate(table)

      assert {%{hit: false}, _} = Code.eval_string(code, a: %{b: %{c: 10}})
      assert {%{hit: true}, _} = Code.eval_string(code, a: %{b: %{c: 9}})
    end

    test "works with a real example" do
      table =
        Tablex.new("""
        F quest.brand.id      || enabled
          (integer, Brand Id) || (bool)
        2 602                 || false
        2 -                   || true
        """)

      code = Tablex.CodeGenerate.generate(table)

      assert {%{enabled: false}, _} = Code.eval_string(code, quest: %{brand: %{id: 602}})
    end
  end
end

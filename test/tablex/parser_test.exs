defmodule Tablex.ParserTest do
  alias Tablex.Table
  use ExUnit.Case

  test "basic parser" do
    box = """
    F   day (string)    weather (string) || activity
    1   Monday,Tuesday  sunny            || walk
    """

    assert %Table{
             hit_policy: :first_hit,
             inputs: [
               %{name: :day, type: :string},
               %{name: :weather, type: :string}
             ],
             outputs: [%{name: :activity, type: :undefined}],
             rules: [
               [1, input: [["Monday", "Tuesday"], "sunny"], output: ["walk"]]
             ]
           } = Tablex.Parser.parse(box, [])
  end

  describe "Multiple rules" do
    test "work" do
      box = """
      F   day (string)    weather (string) || activity
      1   Monday,Tuesday  sunny            || walk
      2   Monday,Tuesday  rainy            || read
      """

      assert %Table{
               hit_policy: :first_hit,
               inputs: [
                 %{name: :day, type: :string},
                 %{name: :weather, type: :string}
               ],
               outputs: [%{name: :activity, type: :undefined}],
               rules: [
                 [1, input: [["Monday", "Tuesday"], "sunny"], output: ["walk"]],
                 [2, input: [["Monday", "Tuesday"], "rainy"], output: ["read"]]
               ]
             } = Tablex.Parser.parse(box, [])
    end
  end

  describe "Empty input" do
    test "works" do
      box = """
      C || name
      1 || Alex
      """

      assert %Table{
               hit_policy: :collect,
               inputs: [],
               outputs: [%{name: :name, type: :undefined}],
               rules: [
                 [1, input: [], output: ["Alex"]]
               ]
             } = Tablex.Parser.parse(box, [])
    end
  end
end

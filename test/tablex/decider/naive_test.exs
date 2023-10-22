defmodule Tablex.Decider.NaiveTest do
  alias Tablex.Decider.Naive

  use ExUnit.Case
  doctest Naive

  describe "match_rule?/2" do
    test "works" do
      assert Naive.match_rule?(
               %{
                 [:car_size] => "mid_size",
                 [:miles_driven] => {:<=, 100},
                 [:rental_duration] => {:>=, 3}
               },
               %{car_size: "mid_size", miles_driven: 100, rental_duration: 7}
             )
    end
  end
end

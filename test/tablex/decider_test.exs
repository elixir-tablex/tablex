defmodule Tablex.DeciderTest do
  alias Tablex.Decider

  use ExUnit.Case

  describe "match_rule?/2" do
    test "works" do
      assert Decider.match_rule?(
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

defmodule Tablex.CodeGenerateTest do
  alias Tablex.CodeGenerate

  use ExUnit.Case
  import CodeGenerate
  import Tablex

  doctest CodeGenerate

  test "it works" do
    table =
      ~t"""
      F GPA       StandardizedTestScores ExtracurricularActivities RecommendationLetters || AdmissionDecision
      1 >=3.5     >1300                  >=2                       >=2                   || Accepted
      2 <3.5      1000..1300             1..2                      1..2                  || Waitlisted
      3 <3.0      -                      -                         -                     || Denied
      4 -         <1000                  >=2                       >=2                   || "Further Review"
      5 -         -                      -                         -                     || Denied
      """

    assert_eval(
      table,
      [
        gpa: 5,
        standardized_test_scores: 0,
        extracurricular_activities: 3,
        recommendation_letters: 3
      ],
      %{admission_decision: "Further Review"}
    )

    assert_eval(
      table,
      [
        gpa: 5,
        standardized_test_scores: 1500,
        extracurricular_activities: 3,
        recommendation_letters: 3
      ],
      %{admission_decision: "Accepted"}
    )
  end

  test "it works with lists" do
    table =
      ~t"""
      F Day                  || OpenHours
      1 Mon,Tue,Wed,Thu,Fri  || "10:00 - 20:00"
      2 Sat                  || "10:00 - 18:00"
      3 Sun                  || "12:00 - 18:00"
      """

    assert_eval(table, [day: "Mon"], %{open_hours: "10:00 - 20:00"})
    assert_eval(table, [day: "Sat"], %{open_hours: "10:00 - 18:00"})
    assert_eval(table, [day: "Sun"], %{open_hours: "12:00 - 18:00"})
  end

  test "it works with a complicated list" do
    table =
      ~t"""
      F OrderValue  ShippingDestination     ShippingWeight || ShippingOption
      1 >=100,97    domestic                -              || "Free Shipping"
      2 -           domestic,international  <=5            || "Standard Shipping"
      3 -           international           >5,null        || "Expedited Shipping"
      4 -           space                   -              || "Rocket Shipping"
      """

    assert_eval(
      table,
      [
        order_value: 97,
        shipping_destination: "domestic",
        shipping_weight: 10_000
      ],
      %{shipping_option: "Free Shipping"}
    )

    assert_eval(
      table,
      [
        order_value: 1000,
        shipping_destination: "domestic",
        shipping_weight: 10
      ],
      %{shipping_option: "Free Shipping"}
    )

    assert_eval(
      table,
      [
        order_value: 1,
        shipping_destination: "international",
        shipping_weight: 10
      ],
      %{shipping_option: "Expedited Shipping"}
    )
  end

  describe "Generating code with `collect` hit policy tables" do
    test "works with simplest collect tables" do
      table =
        ~t"""
        C || grade program
        1 || 1     science
        2 || 2     "visual art"
        3 || 3     music,"visual art"
        """

      assert_eval(
        table,
        [],
        [
          %{grade: 1, program: "science"},
          %{grade: 2, program: "visual art"},
          %{grade: 3, program: ["music", "visual art"]}
        ]
      )
    end

    test "works with inputs" do
      table =
        ~t"""
        C grade || program
        1 1     || science
        2 2     || "visual art"
        3 1..3  || music
        """

      assert_eval(
        table,
        [grade: 1],
        [%{program: "science"}, %{program: "music"}]
      )
    end
  end

  describe "Generating code from a table with `merge` hit policy" do
    test "works" do
      table =
        ~t"""
        M   Continent  Country  Province || Feature1 Feature2
        1   Asia       Thailand -        || true     true
        2   America    Canada   BC,ON    || -        true
        3   America    Canada   -        || true     false
        4   America    US       -        || false    false
        5   Europe     France   -        || true     -
        6   Europe     -        -        || false    true
        """

      assert_eval(
        table,
        [continent: "Asia", country: "Thailand", province: nil],
        %{feature1: true, feature2: true}
      )

      assert_eval(
        table,
        [continent: "America", country: "Canada", province: "BC"],
        %{feature1: true, feature2: true}
      )
    end
  end

  describe "Generating code from a table with `reverse_merge` hit policy" do
    test "works" do
      table =
        ~t"""
        R   Continent  Country  Province || Feature1 Feature2
        1   Europe     -        -        || false    true
        2   Europe     France   -        || true     -
        3   America    US       -        || false    false
        4   America    Canada   -        || true     false
        5   America    Canada   BC,ON    || -        true
        6   Asia       Thailand -        || true     true
        """

      assert_eval(
        table,
        [continent: "Asia", country: "Thailand", province: nil],
        %{feature1: true, feature2: true}
      )

      assert_eval(
        table,
        [continent: "America", country: "Canada", province: "BC"],
        %{feature1: true, feature2: true}
      )
    end
  end

  defp assert_eval(table, args, expect) do
    code = generate(table)

    {ret, _} = Code.eval_string(code, args)
    assert expect == ret
  end
end

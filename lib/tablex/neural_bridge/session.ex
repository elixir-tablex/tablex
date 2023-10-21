defmodule Tablex.NeuralBridge.Session do
  @moduledoc """
  Handles a single session for inference with the rule engine
  """
  require Logger
  alias __MODULE__

  defmodule Error do
    defexception [:message]
  end

  defmodule Solution do
    @moduledoc false
    defstruct text: "", bindings: %{}
  end

  @defined_functions Application.compile_env!(:neural_bridge, :defined_functions)

  defstruct rule_engine: nil,
            id: nil,
            rules_fired: [],
            name: nil,
            solution: [],
            inferred_facts: [],
            errors: [],
            functions_mod: @defined_functions,
            hit_policy: nil

  @type t :: %__MODULE__{rule_engine: any(), id: String.t(), rules_fired: list(rule)}
  @type rule :: %{id: String.t(), given: Retex.Facts.t(), then: list(Retex.Facts.t() | any())}
  @type hit_policy :: :first_hit

  @spec new(String.t(), hit_policy()) :: t()
  def new(id, :first_hit), do: %Session{hit_policy: :first_hit, id: id, rule_engine: Retex.new()}

  @doc "Merge the pre-existing rules with the new set of rules provided"
  @spec add_rules(t(), list(rule)) :: t()
  def add_rules(session = %__MODULE__{rule_engine: rule_engine}, rules)
      when is_list(rules) do
    validate_rules(rules)
    rule_engine = Enum.reduce(rules, rule_engine, &add_production(&2, &1))
    %{session | rule_engine: rule_engine}
  end

  defp validate_rules(rules) do
    Enum.map(rules, fn rule ->
      case rule do
        {:error, error} ->
          raise Error, message: error

        any ->
          any
      end
    end)
  end

  defp add_production(engine, rule) do
    Retex.add_production(engine, rule)
  end

  @doc "Return the reason why a rule would be activated"
  @spec why(t(), map()) :: Retex.Why.t()
  def why(%__MODULE__{rule_engine: rule_engine}, node) do
    Retex.Why.explain(rule_engine, node)
  end

  def add_facts(session = %__MODULE__{rule_engine: rule_engine}, facts) when is_binary(facts) do
    ast_facts = NeuralBridge.SanskritInterpreter.to_production!(facts)
    new_rule_engine = Enum.reduce(ast_facts, rule_engine, &Retex.add_wme(&2, &1))
    new_session = %{session | rule_engine: new_rule_engine}
    apply_rules(new_session)
  end

  def add_facts(session = %__MODULE__{rule_engine: rule_engine}, facts) when is_list(facts) do
    new_rule_engine = Enum.reduce(facts, rule_engine, &Retex.add_wme(&2, &1))
    new_session = %{session | rule_engine: new_rule_engine}

    apply_rules(new_session)
  end

  def add_facts(session = %__MODULE__{}, %Retex.Wme{} = wme) do
    add_facts(session, [wme])
  end

  @doc "Take the list of applicable rules from the agenda and trigger them if they haven't been applied yet"
  @spec apply_rules(t()) :: t()
  def apply_rules(session = %__MODULE__{rule_engine: rule_engine, rules_fired: rules_fired}) do
    rules = extract_applicable_rules(session, rule_engine, rules_fired)
    updated_session = Enum.reduce(rules, session, &apply_rule(&2, &1))
    if Enum.any?(rules), do: apply_rules(updated_session), else: updated_session
  end

  defp extract_applicable_rules(_session, %_{agenda: agenda}, rules_fired), do: agenda -- rules_fired

  defp apply_rule(
         session = %__MODULE__{rules_fired: rules_fired},
         rule = %_{action: actions, bindings: bindings}
       ) do
    {updated_session, _bindings} =
      Enum.reduce(actions, {session, bindings}, &do_apply_rule(&2, &1, rule))

    %{
      updated_session
      | solution: order_solutions(updated_session),
        rules_fired: List.flatten([rule | rules_fired])
    }
  end

  defp order_solutions(%__MODULE__{solution: solutions}) do
    Enum.sort_by(solutions, fn solution -> map_size(solution.bindings) end)
  end

  defp do_apply_rule(
         {session = %__MODULE__{}, bindings},
         function = %NeuralBridge.Function{},
         _rule = %{}
       ) do
    result =
      NeuralBridge.Function.call(
        function.function_name,
        function.arguments,
        bindings,
        session.functions_mod
      )

    {session, Map.put_new(bindings, function.variable_name, result)}
  end

  defp do_apply_rule(
         {session = %__MODULE__{}, bindings},
         wme = %Retex.Wme{},
         _rule
       ) do
    %{rule_engine: rule_engine} = session

    populated =
      for {key, val} <- Map.from_struct(wme), into: %{} do
        val =
          case val do
            "$" <> variable_name ->
              Map.get(bindings, "$" <> variable_name)

            otherwise ->
              otherwise
          end

        {key, val}
      end

    wme = Map.put(struct(Retex.Wme, populated), :timestamp, DateTime.utc_now)
    rule_engine = Retex.add_wme(rule_engine, wme)

    {%{
       session
       | rule_engine: rule_engine,
         inferred_facts: Enum.uniq(session.inferred_facts ++ [wme])
     }, bindings}
  end

  defp do_apply_rule(
         {session = %__MODULE__{}, bindings},
         _wme = {ident, attr, value},
         _rule
       ) do
    %{rule_engine: rule_engine} = session
    rule_engine = Retex.add_wme(rule_engine, Map.put(Retex.Wme.new(ident, attr, value), :timestamp, DateTime.utc_now))

    {%{session | rule_engine: rule_engine}, bindings}
  end
end

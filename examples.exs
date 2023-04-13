import Tablex

sheet = ~RULES"""
F   Age (integer)  Years_of_service  || Holidays (float)
1   >=60           -                 || 3
2   45..59         <30               || 2
3   -              >=30              || 22
4   <18            -                 || 5
5   -              -                 || 10
"""

Tablex.decide(sheet, age: 46, years_of_service: 30)
# => %{holidays: 22}

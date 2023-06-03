defmodule TablexTest do
  use ExUnit.Case
  import DoctestFile

  doctest Tablex
  doctest_file("README.md")
end

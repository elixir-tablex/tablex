defmodule DoctestFile do
  Code.ensure_loaded!(ExUnit.DocTest)

  unless macro_exported?(ExUnit.DocTest, :doctest_file, 1) do
    require Logger

    def doctest_file(file) do
      Logger.warning(
        "`doctest_file(#{inspect(file)})` is skipped because we're running on Elixir #{System.version()}."
      )

      :ok
    end
  end
end

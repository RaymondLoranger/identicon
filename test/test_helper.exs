defmodule TestHelper do
  use PersistConfig

  def doctest(module) when is_atom(module) do
    get_env(:doctest, %{})[module] || []
  end
end

ExUnit.start()

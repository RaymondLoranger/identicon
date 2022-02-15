defmodule IdenticonTest do
  use ExUnit.Case, async: false

  doctest Identicon, only: TestHelper.doctests(Identicon)
end

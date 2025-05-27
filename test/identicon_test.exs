defmodule IdenticonTest do
  use ExUnit.Case, async: true

  doctest Identicon, only: TestHelper.doctests(Identicon)
end

defmodule IdenticonTest do
  use ExUnit.Case, async: true

  # Although Identicon has no doctests...
  doctest Identicon, only: TestHelper.doctests(Identicon)
end

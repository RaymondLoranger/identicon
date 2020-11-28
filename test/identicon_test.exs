defmodule IdenticonTest do
  use ExUnit.Case, async: false

  doctest Identicon, only: TestHelper.doctest(Identicon)
end

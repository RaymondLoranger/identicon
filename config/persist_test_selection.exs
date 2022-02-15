import Config

# Allows to run the doctest(s) of one function at a time...
config :identicon,
  doctests: %{
    Identicon => [
      # show: 1,
      # clear_dir: 0,
    ],
  }

# Allows to run one test at a time...
config :identicon,
  excluded_tags: [
    # :image_test_1,
  ]

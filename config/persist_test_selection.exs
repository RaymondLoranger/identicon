import Config

# Allows to run the doctest(s) of one function at a time...
config :identicon,
  doctest: %{
    Identicon => [
      # show: 1,
    ],
  }

# Allows to run one test at a time...
config :identicon,
  excluded_tags: [
    # :identicon_image_test_1,
  ]

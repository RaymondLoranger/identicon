import Config

# Allows to run the doctest(s) of one or a few functions at a time...
config :identicon,
  doctests: %{
    Identicon => [
      # show: 1,
      # clear_dir: 0,
    ],
  }

# Allows to run one or a few tests at a time...
config :identicon,
  excluded_tags: [
    # :image_test_1,
    # :image_test_2,
    # :image_test_3,
  ]

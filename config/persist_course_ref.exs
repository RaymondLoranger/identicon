use Mix.Config

config :identicon,
  course_ref:
    """
    Based on the course [The Complete Elixir and Phoenix Bootcamp]
    (https://www.udemy.com/the-complete-elixir-and-phoenix-
    bootcamp-and-tutorial/) by Stephen Grider.
    """
    |> String.replace("\n", "")

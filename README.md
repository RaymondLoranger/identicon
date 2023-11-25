# Identicon

Opens a PNG file populated with an identicon derived from an input string.

##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

## Usage

To use the Identicon app, clone `identicon` from GitHub and compile it:

  - git clone https://github.com/RaymondLoranger/identicon
  - cd identicon
  - mix deps.get
  - mix compile

#### Example 1

From the "identicon" folder, start the interactive shell:

  - cd identicon
  - iex -S mix
  - Identicon.show("fig") # Writes to and opens file "fig.png".

#### Example 2

To run the API from a remote shell, start the interactive shell like so:

  - cd identicon
  - iex --sname foo -S mix

Then from a different console, start the Erlang's Windows Shell:

  - iex --sname bar --remsh foo --werl

And in the Erlang shell, run the API:

  - Identicon.show("orange") # Writes to and opens file "orange.png".


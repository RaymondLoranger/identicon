# Identicon

Opens a PNG file populated with an identicon derived from an input string,
a dimension (number of squares across and down) and a size (in pixels).

##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

## Usage

To use the Identicon app, clone `identikon` from GitHub and compile it:

  - git clone https://github.com/RaymondLoranger/identikon
  - cd identikon
  - mix deps.get
  - mix compile

#### Example 1

From the "identikon" folder, start the interactive shell:

  - cd identikon
  - iex -S mix
  - Identicon.show("fig") # Writes to file "fig 250px 5x5.png" and opens it.
  ![alt text](<assets/images/fig 250px 5x5.png>)
  - Identicon.show("pea", 7) # Writes to file "pea 250px 7x7.png" and opens it.
  ![alt text](<assets/images/pea 250px 7x7.png>)

#### Example 2

To run the API in a remote shell, start an interactive shell like so:

  - cd identikon
  - iex --sname foo -S mix

Then from another interactive shell:

  - iex --sname bar --remsh foo
  - Identicon.show("kiwi") # Writes to file "kiwi 250px 5x5.png" and opens it.


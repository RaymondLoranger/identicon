# Identicon

Opens a PNG file populated with an identicon derived from an input string and
a dimension (number of squares across or down).

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
  - Identicon.show("fig") # Writes to file "fig 5x5.png" and opens it.
  ![alt text](<assets/images/fig 5x5.png>)
  - Identicon.show("guava", 7) # Writes to file "guava 7x7.png" and opens it.
  ![alt text](<assets/images/guava 7x7.png>)
#### Example 2

To run the API in a remote shell, start an interactive shell like so:

  - cd identicon
  - iex --sname foo -S mix

Then from another interactive shell:

  - iex --sname bar --remsh foo
  - Identicon.show("orange") # Writes to and opens file "orange.png".


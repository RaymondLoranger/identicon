# Identicon

Generates, writes and displays an identicon for a given input string.

##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

## Usage

To use the Identicon app, clone `identicon` from GitHub and compile it:

  - git clone https://github.com/RaymondLoranger/identicon
  - cd identicon
  - mix deps.get
  - mix compile

## Example

From the "identicon" folder, start the interactive shell:

  - cd identicon
  - iex -S mix
  - Identicon.iconize("banana") # Writes file "banana.png" and displays it.

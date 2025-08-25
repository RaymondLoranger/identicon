# Identicon

Opens a PNG file populated with an identicon derived from an input string,
a dimension (number of squares across and down) and a size (in pixels).

##### Based on the course [The Complete Elixir and Phoenix Bootcamp](https://www.udemy.com/the-complete-elixir-and-phoenix-bootcamp-and-tutorial/) by Stephen Grider.

## Usage

To use `Identicon` locally, run these commands:

```
git clone https://github.com/RaymondLoranger/identicon
cd identicon
mix deps.get
mix escript.build
mix escript.install
```

You can now run the application like so:

```
ic kiwi 7
ic pineapple 9 --size 350 --duration 7 --bell
ic orange 7 -s 300 -d 6
ic guava --no-bell --no-help
ic --help
```

#### Example 1

ic kiwi 7

![alt text](<images/kiwi 250px 7x7.png>)

#### Example 2

ic pineapple 9 --size 350 --duration 7 --bell

![alt text](<images/pineapple 350px 9x9.png>)

#### Example 3

ic orange 7 -s 300 -d 6

![alt text](<images/orange 300px 7x7.png>)

#### Example 4

ic guava --no-bell --no-help

![alt text](<images/guava 250px 5x5.png>)

#### Example 5

ic --help

![alt text](<images/ic help.png>)


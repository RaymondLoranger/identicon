# Identicon

Opens a PNG file populated with an identicon derived from:

- an input string (arbitrary)
- a dimension (number of squares across and down)
- a size (overall width and height in pixels)

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

```
# Creates file "kiwi 250px 7x7.png" and opens it for 3 seconds.
ic kiwi 7
```
![alt text](<images/kiwi 250px 7x7.png>)

#### Example 2

```
# Creates file "pineapple 350px 9x9.png" and opens it for 7 seconds.
ic pineapple 9 --size 350 --duration 7 --bell
```
![alt text](<images/pineapple 350px 9x9.png>)

#### Example 3

```
# Creates file "orange 300px 7x7.png" and opens it for 6 seconds.
ic orange 7 -s 300 -d 6
```
![alt text](<images/orange 300px 7x7.png>)

#### Example 4

```
# Creates file "guava 250px 5x5.png" and opens it for 3 seconds.
ic guava --no-bell --no-help
```
![alt text](<images/guava 250px 5x5.png>)

#### Example 5

```
# Prints info on the escript command's usage and syntax.
ic --help
```
![alt text](<images/ic help.png>)


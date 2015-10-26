# ConnectFour

An implementation of the Connect Four board game in Elixir

See:  http://wsmoak.net/2015/10/22/connect-four-elixir-part-1.html

and http://wsmoak.net/2015/10/24/connect-four-elixir-part-2.html

and http://wsmoak.net/2015/10/26/connect-four-elixir-part-3.html

## Usage

You can print the board grid and make player moves (color, column).

A vertical win (in a column) will be detected.

```
$ iex -S mix

> ConnectFour.Game.print_board

> ConnectFour.Game.move(:red,3)
> ConnectFour.Game.move(:black,3)
```

# Copyright 2015 Wendy Smoak

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule ConnectFour.Board do
  use Supervisor

  @registered_name ConnectFourBoard
  @last_row 6
  @last_column 7

  def start_link do
    Supervisor.start_link(__MODULE__, :no_args, [name: @registered_name])
  end

  def init(:no_args) do
    children =
      for t <- spaces do
        worker(ConnectFour.Space, [t], id: t)
      end
      supervise(children, strategy: :one_for_one)
  end

  def spaces do
    for row <- 1..@last_row, column <- 1..@last_column, do: {row, column}
  end

  def print do
    # upside down - makes finding the first empty space easier
    for row <- @last_row..1, do: print_columns(row)
  end

    def print_columns(row) do
    for col <- 1..@last_column, do: print_space(row,col)
    IO.write "\n"
  end

  def print_space(row, col) do
    agent_name(row,col)
    |> Process.whereis
    |> Agent.get(fn x -> x end)
    |> convert_for_display
    |> IO.write
  end

  def convert_for_display(agent_state) do
    case agent_state do
      Empty -> "."
      :red -> "R"
      :black -> "B"
      _ -> "?"
    end
  end

  def agent_name(row,col) do
    String.to_atom("R" <> Integer.to_string(row) <> "C" <> Integer.to_string(col) )
  end

  def place_token(player,col) do
    if is_full?(col) do
      :column_full
    else
      row = first_empty(col)
      place_token(player,row,col)
    end
  end

  def place_token(player,row,col) do
    agent_name(row,col)
    |> Process.whereis
    |> Agent.update(fn _state -> player end)

    if winner?(row,col) do
      :winner
    else
      :move_accepted
    end
  end

  def winner?(row,col) do
    agent_name(row,col)
    |> Process.whereis
    |> Agent.get( &(&1) )
    |> column_winner?(row,col,1)
  end

  def column_winner?(player,row,col,4) do
    true
  end

  def column_winner?(player,row,col,count) when row > 1 and row <= @last_row do
    neighbor = agent_name(row-1,col)
    |> Process.whereis
    |> Agent.get( &(&1) )

    if player == neighbor do
      column_winner?(player,row-1,col,count+1)
    else
      false
    end
  end

  def column_winner?(player,row,col,count) when row == 1 do
    false
  end

  def is_full?(col) do
    agent_name(@last_row,col)
    |> Process.whereis
    |> Agent.get( &(&1) )
    |> (&(&1 != Empty)).()
  end

  def first_empty(col) do
    first_empty(1,col)
  end

  def first_empty(row, col) do
    if empty_space?(row,col) do
      row
    else
      first_empty(row+1,col)
    end
  end

  def empty_space?(row,col) do
    agent_name(row,col)
    |> Process.whereis
    |> Agent.get( &(&1) )
    |> is_empty?
  end

  def is_empty?(val) do
    val == Empty
  end

end

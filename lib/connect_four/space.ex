defmodule ConnectFour.Space do

  def start_link({row,column}) do
    registered_name = String.to_atom("R#{row}C#{column}")
    Agent.start_link(fn -> Empty end, [name: registered_name])
  end

end

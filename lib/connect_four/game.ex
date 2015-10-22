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

defmodule ConnectFour.Game do
  use GenServer

  @registered_name ConnectFourGame

  def start_link do
    GenServer.start_link(__MODULE__, %{}, [name: @registered_name])
  end

  def print_board do
    ConnectFour.Board.print
  end

end

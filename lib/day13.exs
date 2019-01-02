defmodule Cart do
  defstruct [:x, :y, :heading, {:next_turn, :left}]

  def step(%Cart{heading: :west} = cart) do %{cart | x: cart.x - 1} end
  def step(%Cart{heading: :east} = cart) do %{cart | x: cart.x + 1} end
  def step(%Cart{heading: :north} = cart) do %{cart | y: cart.y - 1} end
  def step(%Cart{heading: :south} = cart) do %{cart | y: cart.y + 1} end

  def turn_left(%Cart{heading: :west} = cart) do %{cart | heading: :south} end
  def turn_left(%Cart{heading: :south} = cart) do %{cart | heading: :east} end
  def turn_left(%Cart{heading: :east} = cart) do %{cart | heading: :north} end
  def turn_left(%Cart{heading: :north} = cart) do %{cart | heading: :west} end

  def turn_right(%Cart{heading: :west} = cart) do %{cart | heading: :north} end
  def turn_right(%Cart{heading: :south} = cart) do %{cart | heading: :west} end
  def turn_right(%Cart{heading: :east} = cart) do %{cart | heading: :south} end
  def turn_right(%Cart{heading: :north} = cart) do %{cart | heading: :east} end

  def turn(%Cart{heading: :west} = cart, "/") do %{cart | heading: :south} end
  def turn(%Cart{heading: :east} = cart, "/") do %{cart | heading: :north} end
  def turn(%Cart{heading: :north} = cart, "/") do %{cart | heading: :east} end
  def turn(%Cart{heading: :south} = cart, "/") do %{cart | heading: :west} end

  def turn(%Cart{heading: :west} = cart, "\\") do %{cart | heading: :north} end
  def turn(%Cart{heading: :east} = cart, "\\") do %{cart | heading: :south} end
  def turn(%Cart{heading: :north} = cart, "\\") do %{cart | heading: :west} end
  def turn(%Cart{heading: :south} = cart, "\\") do %{cart | heading: :east} end

  def turn(%Cart{heading: :west} = cart, "-") do cart end
  def turn(%Cart{heading: :east} = cart, "-") do cart end

  def turn(%Cart{heading: :north} = cart, "|") do cart end
  def turn(%Cart{heading: :south} = cart, "|") do cart end

  def intersection(%Cart{next_turn: :left} = cart) do %{turn_left(cart) | next_turn: :straight} end
  def intersection(%Cart{next_turn: :straight} = cart) do %{cart | next_turn: :right} end
  def intersection(%Cart{next_turn: :right} = cart) do %{turn_right(cart) | next_turn: :left} end
  
  def turn(cart, "+") do intersection(cart) end

end

defmodule Day13 do
  def heading_for_char("<"), do: :west
  def heading_for_char("^"), do: :north
  def heading_for_char(">"), do: :east
  def heading_for_char("v"), do: :south

  def char_for_heading(:west), do: "<"
  def char_for_heading(:north), do: "^"
  def char_for_heading(:east), do: ">"
  def char_for_heading(:south), do: "v"

  def extract_carts_line(line, y) do
    carts = Regex.scan(~r/[<>^v]/, line, return: :index) |> Enum.map(fn ([{x, 1}]) ->
      %Cart{x: x, y: y, heading: heading_for_char(String.at(line, x)) }
    end)
    line = Regex.replace(~r/[<>]/, line, "-")
    line = Regex.replace(~r/[v^]/, line, "|")
    {carts, line}
  end
  
  def extract_carts(lines) do
    {carts, lines} = Enum.with_index(lines) |> Enum.map(fn ({line, y}) -> extract_carts_line(line, y) end) |> Enum.unzip
    carts = List.flatten(carts)
    {carts, lines}
  end

  def show(carts, lines) do
    Enum.reduce(carts, lines, fn cart, lines ->
      char = char_for_heading(cart.heading)
      line = Enum.at(lines, cart.y)
      {prefix, suffix} = String.split_at(line, cart.x)
      List.replace_at(lines, cart.y, prefix <> char <> String.slice(suffix, 1..-1))
    end) |> Enum.join("\n")
  end

  def tick_or_crash(cart, other_carts, lines) do
    cart = Cart.step(cart)
    if Enum.any?(other_carts, fn c -> c.x == cart.x && c.y == cart.y end) do
      {:crash, cart.x, cart.y}
    else
      space = Enum.at(lines, cart.y) |> String.at(cart.x)
      Cart.turn(cart, space)
    end
  end

  def tick_subtick(carts, index, lines) when index == length(carts) do carts end
       
  def tick_subtick(carts, index, lines) do
    cart = Enum.at(carts, index)
    {prefix, suffix} = Enum.split(carts, index)
    other_carts = prefix ++ (tl suffix)
    cart_or_crash = tick_or_crash(cart, other_carts, lines)
    case cart_or_crash do
      {:crash, x, y} -> {:crash, x, y}
      cart -> List.replace_at(carts, index, cart) |> tick_subtick(index+1, lines)
    end
  end
  
  def tick(carts, lines) do
    carts = Enum.sort_by(carts, fn cart -> {cart.y, cart.x} end)
    tick_subtick(carts, 0, lines)
  end

  def run(carts, lines) do
    show(carts, lines) |> IO.puts
    carts_or_crash = tick(carts, lines)
    case carts_or_crash do
      {:crash, x, y} -> IO.inspect({x,y})
      carts -> 
        Process.sleep(100)
        run(carts, lines)
    end
  end
end

{carts, lines} = File.read!("day13input.txt") |> String.split("\n") |> Day13.extract_carts
Enum.map(lines, &IO.puts/1)
IO.inspect(carts)

Day13.run(carts, lines)

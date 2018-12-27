defmodule Day12 do
  # pair of lists; [-1,-2,-3,...] [0,1,2,...]
  def show({left, right}, padding \\ 40) do
    pad_list = List.duplicate(".", max(padding - Enum.count(left), 0))
    #IO.inspect({left, Enum.count(left), pad_list})
    ((left ++ pad_list) |> Enum.reverse |> Enum.join) <> "|" <> Enum.join(right)
  end
  
  def at({left, right}, i) do
    if i < 0 do
      Enum.at(left, (-i) - 1)
    else
      Enum.at(right, i)
    end
  end

  def neighborhood5(gen, i) do
    -2..2 |> Enum.map(&Day12.at(gen, i + &1) || ".") |> Enum.join
  end

  def parse_ruleset(rulelines) do
    rulelines |> Enum.map(&String.split(&1, " => ", trim: true) |> List.to_tuple) |> Map.new
  end

  def apply(ruleset, gen) do
    {left, right} = gen
    new_left = -1..(-Enum.count(left)-2) |> Enum.map(&Day12.neighborhood5(gen, &1)) |> Enum.map(&Map.get(ruleset, &1))
    new_right = 0..(Enum.count(right)+1) |> Enum.map(&Day12.neighborhood5(gen, &1)) |> Enum.map(&Map.get(ruleset, &1))
    {new_left, new_right}
  end

  def iterate(ruleset, start_gen, 0) do start_gen end
  def iterate(ruleset, start_gen, n) do
    next_gen = Day12.apply(ruleset, start_gen)
    IO.inspect(show(next_gen))
    iterate(ruleset, next_gen, n-1)
  end

  def score({left, right}) do
    # cheating by ignoring left!
    Enum.with_index(right) |> Enum.filter(fn {e, _} -> e == "#" end) |> Enum.map(fn {_, x} -> x end) |> Enum.sum
  end
end

IO.inspect "hello"
g = {["z", "y", "x"], ["a", "b", "c"]}
Day12.show(g) |> IO.puts

-2..2 |> Enum.map(&Day12.at(g, &1)) |> IO.inspect
Day12.neighborhood5(g, -2) |> IO.inspect
[stateline | [_ | rulelines]] = File.read!("day12input.txt") |> String.trim |> String.split("\n")
IO.inspect stateline
"initial state: " <> state = stateline
gen = {[], String.codepoints(state)}
ruleset = Day12.parse_ruleset(rulelines)
Day12.show(gen) |> IO.puts
#Day12.apply(ruleset, gen) |> Day12.show |> IO.puts

Day12.iterate(ruleset, gen, 20) |> Day12.score |> IO.puts

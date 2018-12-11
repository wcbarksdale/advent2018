defmodule Day7 do
  def candidates(edges, options) do
    {_, edge_to} = Enum.unzip(edges)
    Enum.reject(options, fn x -> Enum.member?(edge_to, x) end) |> Enum.uniq
  end

  def step(edges, options) do
    choice = candidates(edges, options) |> IO.inspect |> Enum.min
    filtered = Enum.reject(edges, fn {f, _} -> f == choice end)
    {choice, filtered, List.delete(options, choice)}
  end

  def run([], []) do
    ""
  end
  
  def run(edges, options) do
    {choice, filtered, opts} = step(edges, options) |> IO.inspect
    choice <> run(filtered, opts)
  end
  
end


edges = File.read!("./day7input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(fn line -> Regex.run(~r/Step (\w+) must be finished before step (\w+) can begin./, line) |> tl |> List.to_tuple end)

edges |> IO.inspect
{f, t} = Enum.unzip(edges)
all_steps = Enum.uniq(f ++ t) |> Enum.sort

all_steps |> IO.inspect

edges |> Day7.run(all_steps) |> IO.inspect

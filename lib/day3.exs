defmodule Day3 do
  def parse_claim(s) do
    captures = Regex.named_captures(~r/#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)/, s)
    IO.inspect(captures)
    Map.new(captures, fn ({k, v}) -> {String.to_atom(k), Integer.parse(v) |> elem(0)} end)
  end

  def place_claim(grid, claim) do
    pairs = for x <- claim[:x]..(claim[:x]+claim[:w]-1),
      y <- claim[:y]..(claim[:y]+claim[:h]-1) do
        {x,y}
    end
    Enum.reduce(pairs, grid, fn pair, grid ->
      Map.update(grid, pair, 1, &(&1 + 1))
    end)
  end

  def all_claims(claims) do
    Enum.reduce(claims, %{}, fn claim, grid -> place_claim(grid, claim) end)
  end

  def multiple_claim_count(grid) do
    Map.values(grid) |> Enum.count(fn x -> x > 1 end)
  end
end

claims = File.read!("./day3input.txt") |> String.split("\n", trim: true) |> Enum.map(&Day3.parse_claim(&1)) |> Enum.to_list
IO.inspect claims
Enum.map(claims, fn (%{:w => w, :h => h}) -> w * h end) |> Enum.sum |> IO.inspect
IO.inspect(Day3.place_claim(%{}, hd(claims)))
IO.inspect(Day3.all_claims(claims) |> Day3.multiple_claim_count)

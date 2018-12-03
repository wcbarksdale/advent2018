defmodule Day1 do
  def parse_number(s) do
    {n, _} = Integer.parse(s)
    n
  end

  def first_repeat(start_freq, changes, already_seen) do
    if MapSet.member?(already_seen, start_freq) do
      start_freq
    else
      [c | cs] = changes
      first_repeat(start_freq + c, cs ++ [c], MapSet.put(already_seen, start_freq))
    end
  end

  def first_repeat(change_list) do
    first_repeat(0, change_list, MapSet.new())
  end
  
end

numbers = File.read!("./day1input.txt") |> String.split |> Stream.map(&Day1.parse_number(&1)) |> Enum.to_list

IO.puts(numbers |> Enum.sum)
IO.puts(Day1.first_repeat([1,-1]))
IO.puts(Day1.first_repeat([3,3,4,-2,-4]))
IO.puts(Day1.first_repeat(numbers))

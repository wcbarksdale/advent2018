defmodule Day2 do
  def count_values(e) do
    Enum.group_by(e, &(&1))
    |> Enum.map(fn ({k, vs}) -> {k, Enum.count(vs)} end)
    |> Enum.into(%{})
  end
  
  def has_n_instances(e, n) do
    count_values(e)
    |> Map.values()
    |> Enum.member?(n)
  end

  def checksum(e) do
    Enum.count(e, &has_n_instances(&1, 2)) * Enum.count(e, &has_n_instances(&1, 3))
  end

  def common(e1, e2) do
    Enum.zip(e1, e2) |> Enum.count(fn ({a, b}) -> a == b end)
  end

  def almost?(e1, e2) do
    common(e1, e2) == Enum.count(e1) - 1
  end

  def almost_matches(ids) do
    for a <- ids, b <- ids, almost?(a,b), do: {a, b}
  end
  
end

box_ids = File.read!("./day2input.txt") |> String.split |> Enum.map(&String.to_charlist(&1)) |> Enum.to_list
IO.inspect(Day2.count_values('abcdabcaa'))
IO.inspect(Day2.has_n_instances('abcdabcaa', 2))
IO.inspect(Day2.has_n_instances('abcdabcaa', 5))
IO.inspect(Day2.checksum(box_ids))

IO.inspect(Day2.common([1,2,3],[0,2,3]))

IO.inspect(Day2.almost_matches(box_ids))

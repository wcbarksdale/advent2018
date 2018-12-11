defmodule Day6 do

  def pairs do
    File.read!("./day6input.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, ", ")
      |> Enum.map(&Integer.parse(&1) |> elem(0))
      |> List.to_tuple end)
  end
    
  def bounds(points) do
    {xs, ys} = Enum.unzip(points)
    {Enum.min(xs)-1, Enum.max(xs)+1, Enum.min(ys)-1, Enum.max(ys)+1}
  end

  # duplicates corners but that doesn't matter much for this
  def border(box) do
    {min_x, max_x, min_y, max_y} = box
    left = for y <- min_y..max_y, do: {min_x, y}
    right = for y <- min_y..max_y, do: {max_x, y}
    top = for x <- min_x..max_x, do: {x, min_y}
    bottom = for x <- min_x..max_x, do: {x, max_y}
    left ++ right ++ top ++ bottom
  end

  def distance(x0, y0, x1, y1) do
    abs(x1 - x0) + abs(y1 - y0)
  end

  def closest(points, x, y) do
    Enum.min_by(points, fn {x0, y0} -> distance(x0, y0, x, y) end)
  end

  # if a point on the outer bounding box is closest to one of our points, the area
  # will be infinite
  def all_escaping(points) do
    points |> bounds |> border
    |> Enum.map(fn {x, y} -> closest(points, x, y) end)
    |> Enum.uniq
  end

  def frequencies_all(points) do
    {min_x, max_x, min_y, max_y} = bounds(points)
    all_pts = for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
    Enum.map(all_pts, fn {x, y} -> closest(points, x, y) end)
    |> Enum.group_by(&(&1))
    |> Enum.into(%{}, fn {k, vs} -> {k, Enum.count(vs)} end)
  end

  def frequencies_excluding_escaping(points) do
    f = frequencies_all(points) |> Enum.to_list
    e = all_escaping(points)
    Enum.reject(f, fn {k, v} -> Enum.member?(e, k) end)
  end

  # 200 * 50 = 10000 in itself so we can't be more than 200 from the border
  def big_bounds(points) do
    {xs, ys} = Enum.unzip(points)
    {Enum.min(xs)-200, Enum.max(xs)+200, Enum.min(ys)-200, Enum.max(ys)+200}
  end

  def sum_distances(points, {x, y}) do
    Enum.map(points, fn {x0, y0} -> distance(x0, y0, x, y) end) |> Enum.sum
  end
  
  def contained(points, limit \\ 10000) do
    {min_x, max_x, min_y, max_y} = big_bounds(points)
    all_pts = for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
    Enum.filter(all_pts, fn p -> sum_distances(points, p) < limit end) |> Enum.count
  end
end

Day6.pairs |> IO.inspect
Day6.pairs |> Day6.bounds |> IO.inspect

Day6.border({0,3,2,4}) |> IO.inspect
Day6.pairs |> Day6.all_escaping |> IO.inspect
freqs = Day6.pairs |> Day6.frequencies_excluding_escaping |> IO.inspect
Enum.map(freqs, &(elem(&1, 1))) |> Enum.max |> IO.inspect
Day6.pairs |> Day6.contained |> IO.inspect

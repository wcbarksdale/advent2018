defmodule Day10 do
  def parse(filename) do
    File.read!(filename)
    |> String.trim
    |> String.split("\n")
    |> IO.inspect
    |> Enum.map(fn line ->
      Regex.run(~r/position=<(.+),(.+)> velocity=<(.+),(.+)>/, line)
      |> tl
      |> Enum.map(fn s -> String.trim(s) |> Integer.parse |> elem(0) end)
    end)
  end

  def bbox(points) do
    x = Enum.map(points, &(Enum.at(&1, 0)))
    y = Enum.map(points, &(Enum.at(&1, 1)))
    {Enum.min(x), Enum.max(x), Enum.min(y), Enum.max(y)}
  end

  def bbox_size(points) do
    {x_min, x_max, y_min, y_max} = bbox(points)
    (x_max - x_min) * (y_max - y_min)
  end

  def step(points) do
    Enum.map(points, fn [x, y, dx, dy] -> [x+dx, y+dy, dx, dy] end)
  end

  def draw(points) do
    {x_min, x_max, y_min, y_max} = bbox(points)
    point_set = Enum.map(points, fn [x, y, _, _] -> {x, y} end) |> MapSet.new
    lines = for y <- y_min..y_max do
      chars = for x <- x_min..x_max do
        if MapSet.member?(point_set, {x, y}) do "#" else "." end
      end
      Enum.join(chars)
    end
    Enum.join(lines, "\n")
  end

  def iterate(points) do
    draw(points) |> IO.puts
    bbox(points) |> IO.inspect
    Process.sleep(1000)
    iterate(step(points))
  end

  def smallest(points, steps \\ 0) do
    current_size = bbox_size(points)
    next = step(points)
    if current_size < bbox_size(next) do
      draw(points) |> IO.puts
      IO.inspect(steps)
    else
      smallest(next, steps+1)
    end
  end
end

input = Day10.parse("./day10input.txt")
|> IO.inspect

Day10.bbox_size(input) |> IO.inspect
Day10.bbox_size(Day10.step(input)) |> IO.inspect
Day10.bbox_size(Day10.step(Day10.step(input))) |> IO.inspect
Day10.bbox_size(Day10.step(Day10.step(Day10.step(input)))) |> IO.inspect
Day10.bbox_size(Day10.step(Day10.step(Day10.step(Day10.step(input))))) |> IO.inspect

Day10.smallest(input)

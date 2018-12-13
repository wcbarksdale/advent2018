defmodule Day11 do
  def power(x, y, serial) do
    rack_id = x + 10
    p = (rack_id * y + serial) * rack_id
    rem(div(p, 100), 10) - 5
  end

  def power_square(x0, y0, serial, size) do
    powers = for x <- x0..x0+size-1,
                 y <- y0..y0+size-1 do
      power(x,y, serial)
    end
    Enum.sum(powers)
  end

  def best(serial, size \\ 3, max_x \\ 300, max_y \\ 300) do
    scored = for x <- 1..max_x-size,
                 y <- 1..max_y-size do
        {x, y, power_square(x, y, serial, size)}
    end
    Enum.max_by(scored, fn {x, y, score} -> score end)     
  end

  def best_over_sizes(serial) do
    scored = for size <- 1..300 do
      IO.inspect {size, best(serial, size)}
    end
    Enum.max_by(scored, fn {_, {_, _, score}} -> score end)
  end
end

Day11.best(18) |> IO.inspect
Day11.best(42) |> IO.inspect

Day11.best(1955) |> IO.inspect
Day11.best(1955, 1) |> IO.inspect
Day11.best(1955, 300) |> IO.inspect
Day11.best_over_sizes(1955) |> IO.inspect

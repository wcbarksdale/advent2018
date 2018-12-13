defmodule Day11 do
  def power(x, y, serial) do
    rack_id = x + 10
    p = (rack_id * y + serial) * rack_id
    rem(div(p, 100), 10) - 5
  end

  def power_square(x0, y0, serial) do
    powers = for x <- x0..x0+2,
                 y <- y0..y0+2 do
      power(x,y, serial)
    end
    Enum.sum(powers)
  end

  def best(serial, max_x \\ 300, max_y \\ 300) do
    scored = for x <- 1..max_x-2,
                 y <- 1..max_y-2 do
        {x, y, power_square(x, y, serial)}
    end
    Enum.max_by(scored, fn {x, y, score} -> score end)     
  end
end

Day11.best(18) |> IO.inspect
Day11.best(42) |> IO.inspect

Day11.best(1955) |> IO.inspect

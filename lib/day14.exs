defmodule Day14 do
  def new_recipes(digita, digitb) do
    sum = digita + digitb
    if sum >= 10 do
      [1, sum - 10]
    else
      [sum]
    end
  end

  def step(recipes, elfa, elfb) do
    a = Enum.at(recipes, elfa)
    b = Enum.at(recipes, elfb)
    recipes_extended = recipes ++ new_recipes(a, b)
    #IO.inspect({elfa + 1 + a, Enum.count(recipes_extended)})
    new_elfa = rem(elfa + 1 + a, Enum.count(recipes_extended))
    new_elfb = rem(elfb + 1 + b, Enum.count(recipes_extended))
    {recipes_extended, new_elfa, new_elfb}
  end

  def run({recipes, elfa, elfb}, 0) do recipes end

  def run({recipes, elfa, elfb}, count) do
    if rem(count, 1000) == 0 do
      IO.inspect(count)
      end
    #IO.inspect({recipes, elfa, elfb})
    run(step(recipes, elfa, elfb), count-1)
  end
end

Day14.new_recipes(3, 7) |> IO.inspect
Day14.new_recipes(9, 9) |> IO.inspect
Day14.new_recipes(2, 3) |> IO.inspect
Day14.new_recipes(0,0) |> IO.inspect

Day14.run({[3,7],0,1}, 15)
{r, _, _} = Day14.run({[8,4,6,6,0,1],0,1}, 850000)
Enum.drop(r, 846601) |> Enum.take(10) |> IO.inspect

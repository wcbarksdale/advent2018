defmodule Day14 do
  def new_recipes(digita, digitb) do
    sum = digita + digitb
    if sum >= 10 do
      [1, sum - 10]
    else
      [sum]
    end
  end

  def array_append_list(arr, []) do
    arr
  end

  def array_append_list(arr, [x | xs]) do
    array_append_list(:array.set(:array.size(arr), x, arr), xs)
  end
  
  def step(recipes, elfa, elfb) do
    a = :array.get(elfa, recipes)
    b = :array.get(elfb, recipes)
    recipes_extended = array_append_list(recipes, new_recipes(a, b))
    #IO.inspect({elfa + 1 + a, Enum.count(recipes_extended)})
    new_elfa = rem(elfa + 1 + a, :array.size(recipes_extended))
    new_elfb = rem(elfb + 1 + b, :array.size(recipes_extended))
    {recipes_extended, new_elfa, new_elfb}
  end

  def run({recipes, _elfa, _elfb}, 0) do recipes end

  def run({recipes, elfa, elfb}, count) do
    #if rem(count, 1000) == 0 do
    #  IO.inspect(count)
    #  end
    #IO.inspect({recipes, elfa, elfb})
    run(step(recipes, elfa, elfb), count-1)
  end

  def go(initial_list, offset, count \\ 10) do
    run({:array.from_list(initial_list), 0, 1}, offset + count + 100)
    |> :array.to_list
    |> Enum.drop(offset)
    |> Enum.take(count)
  end

  def find_digits(initial, digit_string) do
    run({:array.from_list(initial), 0, 1}, 10000000)
    |> :array.to_list
    |> Enum.join
    |> :binary.match(digit_string)
  end
end

Day14.new_recipes(3, 7) |> IO.inspect
Day14.new_recipes(9, 9) |> IO.inspect
Day14.new_recipes(2, 3) |> IO.inspect
Day14.new_recipes(0,0) |> IO.inspect

#Day14.run({[3,7],0,1}, 15)
#r = Day14.run({:array.from_list([8,4,6,6,0,1]),0,1}, 850000)
#:array.to_list(r) |> Enum.drop(846601) |> Enum.take(10) |> IO.inspect

Day14.go([3,7], 9) |> IO.inspect
Day14.go([3,7], 5) |> IO.inspect
Day14.go([3,7], 18) |> IO.inspect
Day14.go([3,7], 2018) |> IO.inspect
Day14.go([3,7], 846601) |> IO.inspect

a = Day14.run({:array.from_list([3,7]), 0, 1}, 100000000) |> :array.to_list |> Enum.join
:binary.match(a, "51589") |> IO.inspect
:binary.match(a, "01245") |> IO.inspect
:binary.match(a, "92510") |> IO.inspect
:binary.match(a, "59414") |> IO.inspect
:binary.match(a, "846601") |> IO.inspect

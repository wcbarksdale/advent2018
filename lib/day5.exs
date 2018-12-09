defmodule Day5 do
  def letters do
    ?a..?z |> Enum.map(&to_string([&1]))
  end

  def pairs do
    letters |> Enum.flat_map(fn c -> [c <> String.upcase(c), String.upcase(c) <> c] end)
  end

  def pair_pattern do
    "(" <> Enum.join(pairs, "|") <> ")" |> Regex.compile!
  end

  def remove_pairs(s) do
    String.replace(s, pair_pattern, "")
  end

  def remove_until_constant(s) do
    # IO.inspect(String.length(s))
    t = remove_pairs(s)
    if s == t do
      s
    else
      remove_until_constant(t)
    end
  end

  def letter_pattern(c) do
    "(" <> Enum.join([c, String.upcase(c)], "|") <> ")" |> Regex.compile!
  end
  
  def react_without_letter(s, c) do
    String.replace(s, letter_pattern(c), "") |> remove_until_constant
  end

  def score_by_letter(s) do
    Enum.map(letters, fn c ->
      r = react_without_letter(s, c)
      IO.inspect(r)
      {c, r |> String.length}
    end)
  end
end



IO.inspect(Day5.pairs)
IO.inspect(Day5.pair_pattern)

IO.inspect(Day5.remove_pairs("aA"))
IO.inspect(Day5.remove_pairs("aBA"))
IO.inspect(Day5.remove_pairs("BaAb"))

IO.inspect(Day5.react_without_letter("aBA", "b"))


File.read!("./day5input.txt") |> String.trim |> Day5.remove_until_constant |> String.length |> IO.inspect

File.read!("./day5input.txt") |> String.trim |> Day5.score_by_letter |> IO.inspect

defmodule Day9 do
  alias Zippy.ZList, as: Z

  def play(circle, next_marble, max_marble, player, player_count, scores) when next_marble > max_marble do
    {circle, scores}
  end
  
  def play(circle, next_marble, max_marble, player, player_count, scores) when next_marble <= max_marble do
    if rem(next_marble, 1000) == 0 do IO.inspect(next_marble) end
    #IO.inspect(circle |> Z.to_list)
    #IO.inspect([player, circle, next_marble])
    if rem(next_marble, 23) == 0 do
      # player gets this marble, and the marble that will be removed
      circle = Rotary.advance(circle, -7)
      r = Z.current(circle)
      circle = Z.delete(circle)

      score = next_marble + r
      play(circle, next_marble + 1, max_marble, rem(player+1, player_count), player_count, Map.update(scores, player, score, &(&1 + score)))
    else
      # skip two marbles in circle, next marble becomes start of list
      circle = Rotary.advance(circle, 2)
      circle = Z.insert(circle, next_marble)
      play(circle, next_marble + 1, max_marble, rem(player+1, player_count), player_count, scores)
    end
  end

  def start(max_marble, player_count) do
    play(Zippy.ZList.from_list([1, 0]), 2, max_marble, 1, player_count, %{})
  end

  def best_score(scores) do
    Enum.max_by(scores, fn {p, s} -> s end)
  end

  def final(max_marble, player_count) do
    {circle, scores} = start(max_marble, player_count)
    best_score(scores)
  end
 
end

#Day9.final(25, 9) |> IO.inspect
#Day9.final(1618, 10) |> IO.inspect
#Day9.final(7999, 13) |> IO.inspect
#Day9.final(1104, 17) |> IO.inspect
#Day9.final(6111, 21) |> IO.inspect
#Day9.final(5807, 30) |> IO.inspect
#Day9.final(71626, 438) |> IO.inspect
Day9.final(7162600, 438) |> IO.inspect


defmodule Day4 do
  def parse_line(s) do
    cond do
      captures = Regex.named_captures(~r/Guard #(?<guard_id>\d+) begins shift/, s) ->
        {:begin, captures["guard_id"]}
      captures = Regex.named_captures(~r/:(?<minute>\d+)\] falls asleep/, s) ->
        {:sleep, Integer.parse(captures["minute"]) |> elem(0) }
      captures = Regex.named_captures(~r/:(?<minute>\d+)\] wakes up/, s) ->
        {:wake, Integer.parse(captures["minute"]) |> elem(0) }
    end
  end

  def update_with_line({:begin, id}, state) do
    %{state | guard: id, sleep_started: nil}
  end

  def update_with_line({:sleep, t}, state) do
    %{state | sleep_started: t}
  end

  def update_with_line({:wake, t}, %{guard: g, sleep_started: s, sleeps: sleeps}) do
    sleep_finished = %{guard: g, range: s..(t-1)}
    %{guard: g, sleep_started: nil, sleeps: [sleep_finished | sleeps]}
  end

  def construct_sleeps(parsed_lines) do
    %{sleeps: sleeps} = Enum.reduce(parsed_lines, %{guard: nil, sleep_started: nil, sleeps: []}, &update_with_line/2)
    Enum.reverse(sleeps)
  end

  def minutes_slept_by_guard(sleeps) do
    Enum.reduce(sleeps, %{}, fn (%{guard: g, range: r}, mins) -> Map.update(mins, g, Enum.count(r), &(&1 + Enum.count(r))) end)
  end

  def most_frequent(ranges) do
    Enum.flat_map(ranges, &Enum.to_list/1)
    |> Enum.group_by(&(&1))
    |> Enum.max_by(fn {k, v} -> Enum.count(v) end)
    |> elem(0)
  end
end

lines = File.read!("./day4input.txt") |> String.split("\n", trim: true) |> Enum.sort
parsed = lines |> Enum.map(&Day4.parse_line/1)
IO.inspect(parsed)
Day4.construct_sleeps(parsed) |> IO.inspect
{sleepiest, _} = Day4.construct_sleeps(parsed) |> Day4.minutes_slept_by_guard |> Enum.max_by(&(elem(&1, 1)))
IO.inspect(sleepiest)
Day4.construct_sleeps(parsed) |> Enum.filter(fn (%{guard: g}) -> g == sleepiest end) |> Enum.map(fn (%{range: r}) -> r end) |> Day4.most_frequent |> IO.inspect

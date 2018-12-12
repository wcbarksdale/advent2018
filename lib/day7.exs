defmodule Day7 do
  def candidates(edges, options) do
    {_, edge_to} = Enum.unzip(edges)
    Enum.reject(options, fn x -> Enum.member?(edge_to, x) end) |> Enum.uniq
  end

  def step(edges, options) do
    choice = candidates(edges, options) |> IO.inspect |> Enum.min
    filtered = Enum.reject(edges, fn {f, _} -> f == choice end)
    {choice, filtered, List.delete(options, choice)}
  end

  def run([], []) do
    ""
  end
  
  def run(edges, options) do
    {choice, filtered, opts} = step(edges, options) |> IO.inspect
    choice <> run(filtered, opts)
  end

  def duration(task_id) do
    61 + hd(String.to_charlist(task_id)) - ?A
  end

  def assign_ready([], _) do [] end
  def assign_ready(elves, []) do elves end
  
  def assign_ready([:ready | elves], [a | assignments]) do
    [a | assign_ready(elves, assignments)]
  end

  def assign_ready([working | elves], assignments) do
    [working | assign_ready(elves, assignments)]
  end

  def assign(elves, unstarted_tasks, edges) do
    {_, edge_to} = Enum.unzip(edges)
    unblocked = Enum.reject(unstarted_tasks, fn x -> Enum.member?(edge_to, x) end)
    ready_elves = Enum.count(elves, &(&1 == :ready))
    tasks_starting = Enum.take(unblocked, ready_elves)
    assignments = tasks_starting |> Enum.map(&({:working, &1, duration(&1)}))
    new_elves = assign_ready(elves, assignments)
    new_tasks = unstarted_tasks |> Enum.reject(&(Enum.member?(tasks_starting, &1)))
    # note: edges does not change until the task is done
    {new_elves, new_tasks}
  end

  def elf_done({:working, _, 0}) do true end
  def elf_done(_) do false end

  def finish_tasks(elves) do
    # when remaining time = 0, reassign elf to :ready and return task in tasks
    tasks = Enum.filter(elves, &elf_done/1) |> Enum.map(&(elem(&1,1)))
    elves = Enum.map(elves, fn elf ->
      if elf_done(elf) do :ready else elf end
    end)
    {elves, tasks}
  end

  def elf_work({:working, t, n}) do {:working, t, n-1} end
  def elf_work(x) do x end
  
  def part2step([:ready, :ready, :ready, :ready, :ready], [], _, time) do time end
  
  def part2step(elves, unstarted_tasks, edges, time) do
    IO.inspect(["part2step", elves, unstarted_tasks, edges, time])

    #Process.sleep(1000)
    
    {elves, finished_tasks} = finish_tasks(elves)
    edges = Enum.reject(edges, fn {f, _} -> Enum.member?(finished_tasks, f) end)
    {elves, tasks} = assign(elves, unstarted_tasks, edges)

    part2step(Enum.map(elves, &elf_work/1), tasks, edges, time+1)
  end
end


edges = File.read!("./day7input.txt")
|> String.trim
|> String.split("\n")
|> Enum.map(fn line -> Regex.run(~r/Step (\w+) must be finished before step (\w+) can begin./, line) |> tl |> List.to_tuple end)

edges |> IO.inspect
{f, t} = Enum.unzip(edges)
all_steps = Enum.uniq(f ++ t) |> Enum.sort

all_steps |> IO.inspect

edges |> Day7.run(all_steps) |> IO.inspect

Day7.assign([:readyqwer, :ready, :xzcvxcvready, :ready, :ready], ["A", "B", "C"], [{"A", "B"}]) |> IO.inspect
Day7.assign([:ready, :qwerwqer], ["A", "B", "C"], [{"A", "B"}]) |> IO.inspect

Day7.finish_tasks([:readyqwer, {:working, "X", 0}, {:working, "Y", 1}, :ready, :ready]) |> IO.inspect

Day7.assign([:ready, :ready, :ready, :ready, :ready], all_steps, edges) |> IO.inspect
Day7.part2step([:ready, :ready, :ready, :ready, :ready], all_steps, edges, 0)

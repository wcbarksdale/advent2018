defmodule Day8 do
  def parse_trees(0, values, trees) do
    {Enum.reverse(trees), values}
  end
  
  def parse_trees(n, values, trees) do
    {tree, values} = parse_tree(values)
    parse_trees(n-1, values, [tree | trees])
  end
  
  def parse_tree([c | [m | values]]) do
    {children, values} = parse_trees(c, values, [])
    {metadata, values} = Enum.split(values, m)
    {%{metadata: metadata, children: children}, values}
  end

  def parse_exactly_one_tree(values) do
    {tree, []} = parse_tree(values)
    tree
  end

  def metadata_sum(%{metadata: m, children: c}) do
    Enum.sum(m) + (Enum.map(c, &metadata_sum/1) |> Enum.sum)
  end

  def value(%{metadata: m, children: []}) do
    Enum.sum(m)
  end

  def value(%{metadata: m, children: c}) do
    child_values = Enum.map(c, &value/1)
    indexed_values = Enum.map(m, fn i -> Enum.at(child_values, i - 1, 0) end)
    Enum.sum(indexed_values)
  end

end

values = File.read!("./day8input.txt")
|> String.trim
|> String.split
|> Enum.map(fn s -> Integer.parse(s) |> elem(0) end)
|> IO.inspect

tree = Day8.parse_exactly_one_tree(values)

Day8.metadata_sum(tree) |> IO.inspect
Day8.value(tree) |> IO.inspect


{:ok, data} = File.read("data/day12.txt")

defmodule Day12Part1 do
  defp get_starting_position(grid), do: get_position(grid, "S")
  defp get_ending_position(grid), do: get_position(grid, "E")
  defp get_a_position(grid) do
    a = "a" |> String.to_charlist() |> hd
    maps = grid |> Enum.map(fn x -> Enum.find_index(x, fn x -> x == a end) end)
    0..(length(maps) - 1) |> Enum.filter(fn x -> Enum.at(maps, x) != nil end)
    |> Enum.map(fn i ->
      for {y, ^a} <- Enum.at(grid, i) |> Enum.zip(Stream.iterate(0, fn x -> x + 1 end)), do: {i, y}
      end)
    |> Enum.map(fn x -> hd x end)
  end

  defp get_position(grid, char) do
    cols = grid |> Enum.map(&Enum.find_index(&1, fn x -> x == char |> String.to_charlist |> hd end))
    row = cols |> Enum.find_index(fn x -> x != nil end)
    {row, cols |> Enum.find(fn x -> x != nil end)}
  end

  defp normalize_grid(grid) do
    {sx, sy} = get_starting_position grid
    {ex, ey} = get_ending_position grid
    a = "a" |> String.to_charlist() |> hd
    z = "z" |> String.to_charlist() |> hd
    grid = List.replace_at(grid, sx, List.replace_at(Enum.at(grid, sx), sy, a))
    List.replace_at(grid, ex, List.replace_at(Enum.at(grid, ex), ey, z))
  end

  defp can_move_to?(grid, current, to) do
    {x, y} = current
    {tx, ty} = to
    current = Enum.at(grid, x) |> Enum.at(y)
    to_row = Enum.at(grid, tx)
    case to_row do
      nil -> false
      x -> case Enum.at(x, ty) do
        nil -> false
        v -> v - current <= 1
      end
    end
  end

  def solve(grid) do
    starting = get_starting_position(grid)
    ending = get_ending_position(grid)
    grid = normalize_grid(grid)
    queue = PriorityQueue.new()
    set = MapSet.new
    solve(grid, {0, {starting, 0}}, ending, queue, set)

  end

  def solve2(grid) do
    starting = get_a_position(grid)
    ending = get_ending_position(grid)
    grid = normalize_grid(grid)
    Helper.Functions.par_map(starting, fn s ->
        queue = PriorityQueue.new()
        set = MapSet.new
        solve(grid, {0, {s, 0}}, ending, queue, set)
      end) |> Enum.min
  end


  defp solve(_, {_, {ending, steps}}, ending, _, _), do: steps
  defp solve(_, {nil, nil}, _, _, _), do: 9_999_999 # Cannot be solved

  defp solve(grid, {_, {current, steps}}, ending, queue, set) do
    {x, y} = current

    {{next, queue}, set} =
     if MapSet.member?(set, current) do
      {PriorityQueue.pop(queue), set}
    else
      set = MapSet.put(set, current)
      # Select the next positions where we can move and have not been visited
      tos = [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}] |> Enum.filter(fn to -> can_move_to?(grid, current, to) end)
      tos = tos |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
      tos = tos |> Enum.filter(fn to -> !MapSet.member?(set, to) end)
      {ex, ey} = ending

      # Insert the next positions
      queue = tos |> Enum.reduce(queue, fn {x, y}, q ->
        PriorityQueue.put(q, abs(ex - x) + abs(ey - y) + steps + 1, {{x, y}, steps + 1})
      end)

      {PriorityQueue.pop(queue), set}
    end

    solve(grid, next, ending, queue, set)
  end
end

data
|> String.split("\n")
|> Enum.map(&String.to_charlist/1)
|> Day12Part1.solve()
|> IO.inspect()

data
|> String.split("\n")
|> Enum.map(&String.to_charlist/1)
|> Day12Part1.solve2()
|> IO.inspect()

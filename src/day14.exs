{:ok, data} = File.read("data/day14.txt")

# Part 1
defmodule Day14Part1 do
  def parse_input(input) do
    coor = input |> String.split("\n") |> Enum.map(&String.split(&1, " -> ")) |> Enum.map(fn row ->
      row |> Enum.map(&String.split(&1, ",")) |> Enum.map(fn y -> Enum.map(y, &String.to_integer/1) end)
      |> Enum.map(&List.to_tuple/1)
    end)

    {mx, _} = find_min(coor)
    coor = coor |> Enum.map(&Enum.map(&1, fn {x, y} -> {x - mx, y} end))

    empty_grid(coor)
    |> insert_sand()
    |> insert_rock(coor)
  end

  defp find_min(input) do
    all_coor = input |> Enum.flat_map(&Function.identity/1)
    min_x = all_coor |> Enum.map(&elem(&1, 0)) |> Enum.min
    min_y = all_coor |> Enum.map(&elem(&1, 1)) |> Enum.min
    {min_x, min_y}
  end

  defp find_max(input) do
    all_coor = input |> Enum.flat_map(&Function.identity/1)
    max_x = all_coor |> Enum.map(&elem(&1, 0)) |> Enum.max
    max_y = all_coor |> Enum.map(&elem(&1, 1)) |> Enum.max
    {max_x, max_y}
  end

  defp empty_grid(coor) do
    {max_x, max_y} = find_max(coor)
    for _ <- 0..max_y, do: for _ <- 0..max_x, do: '.'
  end

  defp insert_sand(grid) do
    sand_x = 500
    grid |> List.replace_at(0, grid |> Enum.at(0) |> List.replace_at(sand_x, "+"))
  end


  defp insert_rock(grid, {x, y}) do
    grid |> List.replace_at(y, grid |> Enum.at(y) |> List.replace_at(x, "#"))
  end

  defp insert_rock(grid, [{x, y} | [{x, y2} | rest]]) do
    m = min(y, y2)
    grid = 0..abs(y2 - y) |> Enum.reduce(grid, fn i, g -> insert_rock(g, {x, m+i}) end)
    insert_rock(grid, [{x, y2} | rest])
  end

  defp insert_rock(grid, [{x, y} | [{x2, y} | rest]]) do
    m = min(x, x2)
    grid = 0..abs(x2 - x) |> Enum.reduce(grid, fn i, g -> insert_rock(g, {m+i, y}) end)
    insert_rock(grid, [{x2, y} | rest])
  end

  defp insert_rock(grid, coor) when is_list(coor) do
    coor |> Enum.reduce(grid, fn v, g -> insert_rock(g, v) end)
  end

  defp get(_, {x, _}) when x < 0, do: '.'
  defp get(grid, {x, y}) do
   case grid |> Enum.at(y) do
     nil -> '.'
     v -> Enum.at(v, x)
   end
  end

  # part 1
  def solve(grid) do
    {sx, sy} = {grid |> Enum.at(0) |> Enum.find_index(fn x -> x == "+" end) , 0}
    size_y = length(grid)
    size_x = length(Enum.at(grid, 0))

    drop_cube(grid, {sx, sy}, {sx, sy}, {size_x, size_y}, 0)
  end

  defp drop_cube(_, {cube_x, cube_y}, _, {size_x, size_y}, drop_resting) when cube_x >= size_x or cube_x < 0 or cube_y >= size_y, do: drop_resting
  defp drop_cube(grid, {cube_x, cube_y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting) do
    case check_next_position(grid, {cube_x, cube_y}) do
      {x, y} -> drop_cube(grid, {x, y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting)
      :rest -> drop_cube(insert_rock(grid, {cube_x, cube_y}), {sand_x, sand_y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting + 1)
    end
  end

  defp check_next_position(grid, {sand_x, sand_y}) do
    possible = [{sand_x, sand_y + 1}, {sand_x - 1, sand_y + 1}, {sand_x + 1, sand_y + 1}]
    case possible |> Enum.map(&get(grid, &1)) |>Enum.find_index(fn x -> x == '.' end) do
      0 -> {sand_x, sand_y + 1}
      1 -> {sand_x - 1, sand_y + 1}
      2 -> {sand_x + 1, sand_y + 1}
      nil -> :rest

    end
  end
end

data
|> Day14Part1.parse_input()
|> Day14Part1.solve()
|> IO.inspect()

# A lot of repeted code
defmodule Day14Part2 do
  def parse_input(input) do
    coor = input |> String.split("\n") |> Enum.map(&String.split(&1, " -> ")) |> Enum.map(fn row ->
      row |> Enum.map(&String.split(&1, ",")) |> Enum.map(fn y -> Enum.map(y, &String.to_integer/1) end)
      |> Enum.map(&List.to_tuple/1)
    end)

    empty_grid(coor)
    |> insert_sand()
    |> insert_rock(coor)
  end


  defp find_max(input) do
    all_coor = input |> Enum.flat_map(&Function.identity/1)
    max_x = all_coor |> Enum.map(&elem(&1, 0)) |> Enum.max
    max_y = all_coor |> Enum.map(&elem(&1, 1)) |> Enum.max
    {max_x, max_y}
  end

  defp empty_grid(coor) do
    {_, max_y} = find_max(coor)
    for _ <- 0..max_y, do: for _ <- 0..2_000, do: '.'
  end

  defp insert_sand(grid) do
    sand_x = 500
    grid |> List.replace_at(0, grid |> Enum.at(0) |> List.replace_at(sand_x, "+"))
  end

  defp get(grid, {x, y}) do
    {grid,  grid |> Enum.at(y) |> Enum.at(x)}
  end

  defp insert_rock(grid, {x, y}) do
    grid |> List.replace_at(y, grid |> Enum.at(y) |> List.replace_at(x, "#"))
  end

  defp insert_rock(grid, [{x, y} | [{x, y2} | rest]]) do
    m = min(y, y2)
    grid = 0..abs(y2 - y) |> Enum.reduce(grid, fn i, g -> insert_rock(g, {x, m+i}) end)
    insert_rock(grid, [{x, y2} | rest])
  end

  defp insert_rock(grid, [{x, y} | [{x2, y} | rest]]) do
    m = min(x, x2)
    grid = 0..abs(x2 - x) |> Enum.reduce(grid, fn i, g -> insert_rock(g, {m+i, y}) end)
    insert_rock(grid, [{x2, y} | rest])
  end

  defp insert_rock(grid, coor) when is_list(coor) do
    coor |> Enum.reduce(grid, fn v, g -> insert_rock(g, v) end)
  end

  def solve(grid) do
    {sx, sy} = {grid |> Enum.at(0) |> Enum.find_index(fn x -> x == "+" end) , 0}
    size_y = length(grid)
    size_x = length(Enum.at(grid, 0))

    grid = grid ++ (for _ <- 0..(size_x - 1), do: '.') ++ (for _ <- 0..(size_x - 1), do: "#")

    size_y = length(grid)

    drop_cube(grid, {sx, sy}, {sx, sy}, {size_x, size_y}, 0)
  end

  defp drop_cube(grid, {cube_x, cube_y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting) do
    case {{check_next_position(grid, {cube_x, cube_y}), {sand_x, sand_y}}, {cube_x, cube_y}} do
      {{x, y}, _} -> drop_cube(grid, {x, y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting)
      {:rest, {sand_x, sand_y}} -> drop_resting
      {:rest, _} -> drop_cube(insert_rock(grid, {cube_x, cube_y}), {sand_x, sand_y}, {sand_x, sand_y}, {size_x, size_y}, drop_resting + 1)
    end
  end

  defp check_next_position(grid, {sand_x, sand_y}) do
    possible = [{sand_x, sand_y + 1}, {sand_x - 1, sand_y + 1}, {sand_x + 1, sand_y + 1}]
    case possible |> Enum.map(&get(grid, &1)) |> Enum.find_index(fn x -> x == '.' end) do
      0 -> {sand_x, sand_y + 1}
      1 -> {sand_x - 1, sand_y + 1}
      2 -> {sand_x + 1, sand_y + 1}
      nil -> :rest

    end
  end
end

data
|> Day14Part2.parse_input()
|> Day14Part2.solve()
|> IO.inspect()

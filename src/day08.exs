{:ok, data} = File.read("data/day08.txt")

# Part 1
defmodule Day08Part1 do
 def tree_visible(coor, matrix) do
  row = get_row(coor, matrix)
  col = get_column_as_row(coor, matrix)
  check_row(elem(coor, 0), row) or check_row(elem(coor, 1), col)
 end

 defp visible(val, row_to_check), do: (row_to_check |> Enum.filter(fn x -> x >= val end) |> Enum.count()) == 0

 defp check_row(to_split, row) do
   {left, right} = String.split_at(row, to_split)
   [val | right ] = right |> String.to_charlist()
   left = left |> String.to_charlist()

   visible(val, left) or visible(val, right)
 end

 def get_row({_, y}, matrix), do: matrix |> Enum.at(y)

 def get_column_as_row({x, _}, matrix) do
   matrix = matrix |> Enum.map(&String.to_charlist/1)
   matrix |> Enum.map(&Enum.at(&1, x)) |> List.to_string()
 end
end

matrix = data
|> String.split("\n", trim: :true)

height = matrix |> length()
width = matrix |> Enum.at(0) |> String.length()



visible = for x <- 0..(width - 1), y <- 0..(height - 1), do: Day08Part1.tree_visible({x, y}, matrix)
visible |> Enum.filter(&Function.identity/1) |> length() |> IO.puts()

# Part 2
defmodule Day08Part2 do
  # The tree is visible
  def get_scenic_score({x, y}, matrix) do
    row = Day08Part1.get_row({x, y}, matrix)
    col = Day08Part1.get_column_as_row({x, y}, matrix)
    scenic_score(x, row) * scenic_score(y, col)
  end

  defp scenic_score(to_split, row) do
   {left, right} = String.split_at(row, to_split)
   [val | right ] = right |> String.to_charlist()
   left = left |> String.to_charlist()
   count(val, left, :left) * count(val, right, :right)
  end

  defp count(val, part, :left), do: count(val, part |> Enum.reverse, :right)
  defp count(val, part, :right) do
    case part |> Enum.find_index(fn x -> x >= val end) do
      nil -> length(part)
      x -> x + 1
    end
  end
end

coordinates = for x <- 1..(width - 2), y <- 1..(height - 2), do: {x, y}
coordinates |> Enum.filter(fn x -> Day08Part1.tree_visible(x, matrix) end) |> Enum.map(fn x -> Day08Part2.get_scenic_score(x, matrix) end)
|> Enum.max |> IO.inspect()

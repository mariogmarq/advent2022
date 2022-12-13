{:ok, data} = File.read("data/day13.txt")

# Part 1
defmodule Day13 do
  def parse_input(input), do: input |> Enum.map(&parse_tuple/1)
  defp parse_tuple({first, second}) do
    {first, _} = Code.eval_string(first)
    {second, _} = Code.eval_string(second)
    {first, second}
  end

  def count_right_order(input) do
    input |> Enum.zip(Stream.iterate(1, fn x -> x + 1 end))
    |> Enum.filter(fn {{x, y}, _} -> right_order(x, y) end)
    |> Enum.reduce(0, fn {_, x}, acc -> acc + x end)
  end

  defp right_order([], []), do: :continue
  defp right_order([], [_ | _]), do: true
  defp right_order([_ | _], []), do: false
  defp right_order([x | rest1], [x | rest2]) when is_integer(x), do: right_order(rest1, rest2)
  defp right_order([x | _], [y | _]) when is_integer(x) and is_integer(y) do
    x < y
  end

  defp right_order([x | rest1], [y | rest2]) when is_integer(x) and is_list(y) do
    case right_order([x], y) do
      :continue -> right_order(rest1, rest2)
      e -> e
    end
  end

  defp right_order([x | rest1], [y | rest2]) when is_list(x) and is_integer(y) do
    case right_order(x, [y]) do
      :continue -> right_order(rest1, rest2)
      e -> e
    end
  end

  defp right_order([x | rest1], [y | rest2]) when is_list(x) and is_list(y) do
    case right_order(x, y) do
      :continue -> right_order(rest1, rest2)
      x -> x
    end
  end

  def sort(input) do
    list = (input |> Enum.flat_map(&Tuple.to_list/1)) ++ [[[2]], [[6]]]
    list |> Enum.sort(fn x, y -> right_order(x, y) end)
    |> Enum.zip(Stream.iterate(1, fn x -> x + 1 end))
    |> Enum.filter(fn {l, _} -> l == [[2]] or l == [[6]] end)
    |> Enum.reduce(1, fn {_, i}, acc -> acc * i end)
  end
end

data
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(&List.to_tuple/1)
|> Day13.parse_input()
|> Day13.count_right_order()
|> IO.inspect()

# Part 2

data
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(&List.to_tuple/1)
|> Day13.parse_input()
|> Day13.sort()
|> IO.inspect()

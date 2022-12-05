{:ok, data} = File.read("data/day03.txt")

# Part one

defmodule Day03Part1 do
  def find_common_letters({first_part, second_part}) do
    second_part
    |> String.graphemes()
    |> Enum.find(fn x ->
      x in (first_part
            |> String.graphemes()
            |> Enum.uniq())
    end)
  end

  def substract(<<v::utf8>>) when v < 97, do: v - 65 + 27
  def substract(<<v::utf8>>), do: v - 97 + 1
end

data
|> String.split("\n")
|> Enum.map(&String.split_at(&1, String.length(&1) |> Integer.floor_div(2)))
|> Enum.map(&Day03Part1.find_common_letters/1)
|> Enum.map(&Day03Part1.substract/1)
|> Enum.sum()
|> IO.puts()

# Part 2
defmodule Day03Part2 do
  def find_badge(values) do
    [a, b, c] = values |> Enum.map(fn x -> String.graphemes(x) |> Enum.uniq end)
    a_in_b = a |> Enum.filter(&Kernel.in(&1, b))
    a_in_b |> Enum.find(&Kernel.in(&1, c))
  end
end

data
|> String.split("\n")
|> Enum.chunk_every(3)
|> Enum.map(&Day03Part2.find_badge/1)
|> Enum.map(&Day03Part1.substract/1)
|> Enum.sum
|> IO.puts()

{:ok, data} = File.read("data/day10.txt")

# Part 1
defmodule Day10Part1 do
  def create_instructions(input) do
      input |> Enum.map(&parse_instruction/1) |> Enum.flat_map(&Function.identity/1)
  end
  defp parse_instruction("noop"), do: ["noop"]
  defp parse_instruction("addx " <> v), do: ["noop", "addx " <> v]
  def execute([], _register), do: []
  def execute(["noop" | rest], register), do: [register | execute(rest, register)]
  def execute(["addx " <> v | rest], register), do: [register | execute(rest, register + String.to_integer(v))]
end

data
|> String.split("\n")
|> Day10Part1.create_instructions()
|> Day10Part1.execute(1)
|> Enum.zip(Stream.iterate(1, fn x -> x + 1 end))
|> Enum.filter(fn {_, pos} -> pos == 20 || rem(pos, 40) == 20 end)
|> Enum.reduce(0, fn {v, pos}, acc -> acc + v * pos end)
|> IO.inspect()

# Part 2
defmodule Day10Part2 do
  def empty_matrix(w, h), do: for _ <- 1..(w * h), do: '.'
  def parse_value({val, pos}, matrix) do
    if abs(val - pos) > 1 do
      matrix
    else
      List.update_at(matrix, pos - 1, fn _ -> '#' end)
    end
  end
end

data
|> String.split("\n")
|> Day10Part1.create_instructions()
|> Day10Part1.execute(1)
|> Enum.zip(Stream.iterate(0, fn x -> x + 1 end))
|> Enum.map(fn {val, pos} ->
  r = rem(pos, 40)
  if val == r or val == r - 1 or val == r + 1  do
    '#'
  else
    '.'
  end
end)
|> Enum.chunk_every(40)
|> Enum.map_join("\n", &List.to_string/1)
|> IO.puts()

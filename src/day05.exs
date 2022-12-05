{:ok, data} = File.read("data/day05.txt")

# Part 1
defmodule Day05Part1 do
  def get_crates([stack, moves]) do
    crates =
      stack
      |> String.split("\n")
      |> Enum.drop(-1)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.drop(&1, 1))
      |> Enum.map(&Enum.take_every(&1, 4))

    cn = crates |> Enum.at(-1) |> Enum.count()

    crates =
      for n <- 0..(cn - 1),
          do:
            crates
            |> Enum.map(&Enum.at(&1, n))
            |> List.to_string()
            |> String.trim_leading()
            |> String.to_charlist()

    [crates, moves]
  end

  def get_moves([stack, moves]) do
    m =
      moves
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn [_, num, _, from, _, to] -> [num, from, to] end)
      |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

    [stack, m]
  end

  def process_move([stack, []]), do: stack

  def process_move([stack, [move | remaining_moves]]) do
    [num, from, to] = move

    original_stack = stack |> Enum.at(from - 1)
    crates_taken = original_stack |> Enum.take(num) |> Enum.reverse()
    stack = stack |> List.replace_at(from - 1, original_stack |> Enum.drop(num))

    stack =
      stack
      |> List.replace_at(to - 1, [crates_taken | Enum.at(stack, to - 1)] |> List.to_charlist())

    process_move([stack, remaining_moves])
  end
end

data
|> String.split("\n\n")
|> Day05Part1.get_crates()
|> Day05Part1.get_moves()
|> Day05Part1.process_move()
|> Enum.map(&Enum.take(&1, 1))
|> List.to_string()
|> IO.inspect()

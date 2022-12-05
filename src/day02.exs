{:ok, data} = File.read("data/day02.txt")


# Part 1
defmodule Day02Part1 do
  def norm([x, y]) do
    case y do
      "Y" -> [x, "B"]
      "X" -> [x, "A"]
      "Z" -> [x, "C"]
    end
  end

  def winning_points([x, x]), do: [x, 3]
  def winning_points(["A", "B"]), do: ["B", 6]
  def winning_points(["B", "C"]), do: ["C", 6]
  def winning_points(["C", "A"]), do: ["A", 6]
  def winning_points([_, y]), do: [y, 0]

  def total_points(["A", s]), do: 1 + s
  def total_points(["B", s]), do: 2 + s
  def total_points(["C", s]), do: 3 + s
end

data
|> String.split("\n")
|> Enum.map(&String.split(&1, " "))
|> Enum.map(&Day02Part1.norm/1)
|> Enum.map(fn x -> x |> Day02Part1.winning_points |> Day02Part1.total_points end)
|> Enum.sum
|> IO.puts()

# Part two
defmodule Day02Part2 do
  def determine_move([x, "Y"]), do: [x, x]
  def determine_move(["A", "X"]), do: ["A", "C"]
  def determine_move(["B", "X"]), do: ["B", "A"]
  def determine_move(["C", "X"]), do: ["C", "B"]
  def determine_move(["A", "Z"]), do: ["A", "B"]
  def determine_move(["B", "Z"]), do: ["B", "C"]
  def determine_move(["C", "Z"]), do: ["C", "A"]
end

data
|> String.split("\n")
|> Enum.map(&String.split(&1, " "))
|> Enum.map(&Day02Part2.determine_move/1)
|> Enum.map(fn x -> x |> Day02Part1.winning_points |> Day02Part1.total_points end)
|> Enum.sum
|> IO.puts

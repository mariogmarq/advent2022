{:ok, data} = File.read("data/day04.txt")

# Part 1
data
|> String.split("\n")
|> Enum.map(&String.split(&1, ","))
|> Enum.map(&Enum.map(&1, fn x -> String.split(x, "-") end))
|> Enum.map(&Enum.map(&1, fn x -> Enum.map(x, fn y -> String.to_integer(y) end) end))
|> Enum.filter(fn [[a, b], [c, d]] -> (a <= c and d <= b) or (c <= a and b <= d) end)
|> Enum.count()
|> IO.puts()

# Part 2
data
|> String.split("\n")
|> Enum.map(&String.split(&1, ","))
|> Enum.map(&Enum.map(&1, fn x -> String.split(x, "-") end))
|> Enum.map(&Enum.map(&1, fn x -> Enum.map(x, fn y -> String.to_integer(y) end) end))
|> Enum.filter(fn [[a, b], [c, d]] -> (a <= d and c <= a) or (c <= b and b <= d) or (a <= c and c <= b) or (a <= d and d <= b) end)
|> Enum.count()
|> IO.puts()

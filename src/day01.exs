{:ok, data} = File.read("data/day01.txt")

# Part one
data
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
|> Enum.map(&Enum.sum/1)
|> Enum.max
|> IO.inspect

# Part two
data
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
|> Enum.map(&Enum.sum/1)
|> Enum.sort(:desc)
|> Enum.slice(0..2)
|> Enum.sum
|> IO.inspect

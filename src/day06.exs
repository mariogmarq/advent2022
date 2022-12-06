{:ok, data} = File.read("data/day06.txt")

# Part 1
data
|> String.to_charlist
|> Enum.chunk_every(4, 1, :discard)
|> Enum.find_index(fn x -> (x |> Enum.uniq |> Enum.count) == (x |> Enum.count) end)
|> (&(&1 + 4)).()
|> IO.puts

# Part 2
data
|> String.to_charlist
|> Enum.chunk_every(14, 1, :discard)
|> Enum.find_index(fn x -> (x |> Enum.uniq |> Enum.count) == (x |> Enum.count) end)
|> (&(&1 + 14)).()
|> IO.puts

{:ok, data} = File.read("data/day07.txt")

# Part1
defmodule Day07Part1 do

  defp process_commands([], _current_path, files), do: files
  defp process_commands(["$ cd /" | rest], _current_path, files), do: process_commands(rest, "/", files)
  defp process_commands(["$ cd .." | rest], current_path, files) do
    new_path = current_path |> String.split("/") |> Enum.reverse |> Enum.drop(2) |> Enum.reverse |> Enum.join("/")
    process_commands(rest, new_path <> "/", files)
  end
  defp process_commands(["$ cd " <> a | rest], current_path, files), do: process_commands(rest, current_path <> a <> "/", files)
  defp process_commands(["$ ls" | rest], current_path, files), do: process_commands(rest, current_path, files)
  defp process_commands(["dir" <> _ | rest], current_path, files), do: process_commands(rest, current_path, files)
  defp process_commands([file | rest], current_path, files) do
    file_size = file |> String.split(" ") |> Enum.at(0) |> String.to_integer
    file_name = file |> String.split(" ") |> Enum.at(1)
    process_commands(rest, current_path, [{file_size, current_path <> file_name} | files])
  end

  def process_data(input), do: process_commands(input, "/", [])

  defp store_size_on_map([], _size, map, _path), do: map
  defp store_size_on_map([dir | rest], size, map, path) do
    dir = path <> dir <> "/"
    map = Map.put_new(map, dir, 0)
    {:ok, val} = Map.fetch(map, dir)
    map = Map.put(map, dir, val + size)

    store_size_on_map(rest, size, map, dir)
  end

  def reduce_size_on_dir(input), do: reduce_size_on_dir(input, %{})
  defp reduce_size_on_dir([], map), do: map
  defp reduce_size_on_dir([{size, name} | rest], map) do
    dirs = name |> String.split("/") |> Enum.reverse() |> Enum.drop(1) |> Enum.reverse
    map = store_size_on_map(dirs, size, map, "")
    reduce_size_on_dir(rest, map)
  end
end

data
|> String.split("\n", trim: :true)
|> Day07Part1.process_data
|> Day07Part1.reduce_size_on_dir
|> Enum.filter(fn {a, v} -> v <= 100000 end)
|> Enum.reduce(0, fn {_, a}, acc -> a + acc end)
|> IO.puts

# Part 2
dirs = data
|> String.split("\n", trim: :true)
|> Day07Part1.process_data
|> Day07Part1.reduce_size_on_dir

{:ok, root_size} = Map.fetch(dirs, "/")
available_size = 70000000 - root_size
necesary_size = 30000000 - available_size

dirs
|> Enum.filter(fn {_, v} -> v >= necesary_size end)
|> Enum.min_by(&elem(&1, 1))
|> elem(1)
|> IO.puts

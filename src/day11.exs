{:ok, data} = File.read("data/day11.txt")

# Part 1
defmodule Day11Part1 do
  def parse_monkey(["Monkey " <> _ | rest]), do: parse_monkey_ins(rest, %{:times => 0})

  defp  parse_monkey_ins([], map), do: map
  defp parse_monkey_ins(["Starting items: " <> v | rest], map) do
    item_list = String.trim(v) |> String.split(", ") |> Enum.map(&String.to_integer/1)
    parse_monkey_ins(rest, Map.put(map, :items, item_list))
  end

  defp parse_monkey_ins(["Operation: new = " <> v | rest], map) do
   {left, operator, right} = v |> String.trim() |> String.split(" ") |> List.to_tuple()

   ins = fn worry ->
    left = case left do
      "old" -> worry
      x -> String.to_integer(x)
    end

    right = case right do
      "old" -> worry
      x -> String.to_integer(x)
    end

    case operator do
      "+" -> left + right
      "*" -> left * right
    end
   end

   parse_monkey_ins(rest, Map.put(map, :op, ins))
  end

  defp parse_monkey_ins(["Test: divisible by " <> v | rest], map), do: parse_monkey_ins(rest, Map.put(map, :divisible, String.to_integer(v)))
  defp parse_monkey_ins(["If true: throw to monkey " <> v | rest], map), do: parse_monkey_ins(rest, Map.put(map, :iftrue, String.to_integer(v)))
  defp parse_monkey_ins(["If false: throw to monkey " <> v | rest], map), do: parse_monkey_ins(rest, Map.put(map, :iffalse, String.to_integer(v)))

  def round(monkey_data, reduced_worry) do
    0..(length(monkey_data) - 1) |> Enum.reduce(monkey_data, fn i, acc -> run_monkey({Enum.at(acc, i), i}, acc, reduced_worry) end)
  end

  defp run_monkey({%{items: []}, _}, monkey_data, _), do: monkey_data
  defp run_monkey({monkey, id}, monkey_data, rw) do
    # El monkey no se actualiza en el reduce, comprobar
    item = hd monkey.items
    {monkey, monkey_data} = run_item(item, monkey, monkey_data, rw)
    monkey_data = List.replace_at(monkey_data, id, monkey)
    run_monkey({monkey, id}, monkey_data, rw)
  end


  defp run_item(item, monkey, monkey_data, rw) do
    monkey = %{monkey | :items => tl(monkey.items), :times => monkey.times + 1}
    item = rw.(monkey.op.(item))
    id = if rem(item, monkey.divisible) == 0 do
      monkey.iftrue
    else
      monkey.iffalse
    end

    monke = Enum.at(monkey_data, id)
    monke = %{monke | :items => monke.items ++ [item]}
    monkey_data = List.replace_at(monkey_data, id, monke)
    {monkey, monkey_data}
  end


end


data = data
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(&Enum.map(&1, fn x -> String.trim(x) end))
|> Enum.map(&Day11Part1.parse_monkey/1)

0..19
|> Enum.reduce(data, fn _, data -> Day11Part1.round data, fn x -> Integer.floor_div(x, 3) end end)
|> Enum.map(fn monke -> monke.times end)
|> Enum.sort(:desc)
|> Enum.slice(0..1)
|> Enum.reduce(fn x, y -> x * y end)
|> IO.puts()

# Part 2
# LCM since all mods are prime :)
mod = data |> Enum.map(fn x -> x.divisible end) |> Enum.reduce(fn x, y -> x * y end)

0..9_999
# Putting the LCM this way allows to keep the item value smallers
|> Enum.reduce(data, fn _, data -> Day11Part1.round data, fn x -> rem(x, mod) end end)
|> Enum.map(fn monke -> monke.times end)
|> Enum.sort(:desc)
|> Enum.slice(0..1)
|> Enum.reduce(fn x, y -> x * y end)
|> IO.puts()

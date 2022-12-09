{:ok, data} = File.read("data/day09.txt")

defmodule Day09 do
  def process_moves(moves, knots) do
    rope = for _ <- 0..(knots - 1), do: {0, 0}
    process_moves(moves, rope, %{{0, 0} => true})
  end

  defp process_moves([], _rope, tail_positions), do: tail_positions |> Map.keys() |> length()
  defp process_moves([move | rest], rope, tail_pos) do
    {rope, tail_pos} = process_move(move, rope, tail_pos)
    process_moves(rest, rope, tail_pos)
  end

  defp need_to_move_tail?({hx, hy}, {tx, ty}), do: max(abs(hx - tx), abs(hy  -  ty)) > 1

  defp process_move(move, rope, tail_positions) do
    # need to move the head step by step
    {dir, times} = move
    new_moves = for _ <- 0..(times - 1), do: {dir, 1}
    process_list_of_single_moves(new_moves, rope, tail_positions)
  end

  defp process_list_of_single_moves([], rope, tail_pos), do: {rope, tail_pos}
  defp process_list_of_single_moves([move | rest], [head_coor | tail], tail_pos) do
    head_coor = move_single_head(move, head_coor)
    {rope, tail_pos} = propagate_move([head_coor | tail], tail_pos)

    process_list_of_single_moves(rest, rope, tail_pos)
  end

  defp propagate_move([head_coor | [next_knot | rest]], tail_pos) do

    next_knot = if need_to_move_tail?(head_coor, next_knot) do
      move_tail(head_coor, next_knot)
    else
      next_knot
    end

   {rest, tail_pos} = propagate_move([next_knot | rest], tail_pos)
   {[head_coor | rest], tail_pos}
  end
  defp propagate_move([tail | []], tail_pos) do
    tail_pos = Map.put_new(tail_pos, tail, true)
    {[tail], tail_pos}
  end

  defp move_single_head({dir, 1}, {hx, hy}) do
    case dir do
      "R"  -> {hx + 1, hy}
      "L"  -> {hx - 1, hy}
      "U"  -> {hx, hy + 1}
      "D"  -> {hx, hy - 1}
    end
  end

  defp move_tail({hx, hy}, {hx, ty}) when hy > ty, do: {hx, ty + 1}
  defp move_tail({hx, hy}, {hx, ty}) when hy < ty, do: {hx, ty - 1}
  defp move_tail({hx, hy}, {tx, hy}) when hx > tx, do: {tx + 1, hy}
  defp move_tail({hx, hy}, {tx, hy}) when hx < tx, do: {tx - 1, hy}
  defp move_tail({hx, hy}, {tx, ty}) when hx > tx and hy > ty, do: {tx + 1, ty + 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx > tx and hy < ty, do: {tx + 1, ty - 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx < tx and hy > ty, do: {tx - 1, ty + 1}
  defp move_tail({hx, hy}, {tx, ty}) when hx < tx and hy < ty, do: {tx - 1, ty - 1}
end

# Part 1
data
|> String.split("\n")
|> Enum.map(&String.split(&1, " "))
|> Enum.map(fn [dir, num] -> {dir, String.to_integer(num)} end)
|> Day09.process_moves(2)
|> IO.puts()

# Part 2
data
|> String.split("\n")
|> Enum.map(&String.split(&1, " "))
|> Enum.map(fn [dir, num] -> {dir, String.to_integer(num)} end)
|> Day09.process_moves(10)
|> IO.puts()

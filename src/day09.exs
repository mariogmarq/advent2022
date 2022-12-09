{:ok, data} = File.read("data/day09.txt")

# Part 1
defmodule Day09Part1 do
  def process_moves(moves), do: process_moves(moves, {0, 0}, {0, 0}, %{{0, 0} => true})
  defp process_moves([], _head_coordinates, _tail_coordinates, tail_positions), do: tail_positions |> Map.keys() |> length()
  defp process_moves([move | rest], head_coordinates, tail_coordinates, tail_positions) do
    {h, t, tp} = process_move(move, head_coordinates, tail_coordinates, tail_positions)
    process_moves(rest, h, t, tp)
  end

  defp need_to_move_tail?({hx, hy}, {tx, ty}), do: max(abs(hx - tx), abs(hy  -  ty)) > 1

  defp process_move(move, {hx, hy}, tail_coordinates, tail_positions) do
    # need to move the head step by step
    {dir, times} = move
    new_moves = for _ <- 0..(times - 1), do: {dir, 1}
    process_list_of_single_moves(new_moves, {hx, hy}, tail_coordinates, tail_positions)
  end

  defp process_list_of_single_moves([], head_coor, tail_coor, tail_pos), do: {head_coor, tail_coor, tail_pos}
  defp process_list_of_single_moves([move | rest], head_coor, tail_coor, tail_pos) do
    head_coor = move_single_head(move, head_coor)

    tail_coor = if need_to_move_tail?(head_coor, tail_coor) do
      move_tail(head_coor, tail_coor)
    else
      tail_coor
    end

    tail_pos = Map.put_new(tail_pos, tail_coor, true)
    process_list_of_single_moves(rest, head_coor, tail_coor, tail_pos)
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


data
|> String.split("\n")
|> Enum.map(&String.split(&1, " "))
|> Enum.map(fn [dir, num] -> {dir, String.to_integer(num)} end)
|> Day09Part1.process_moves()
|> IO.inspect()

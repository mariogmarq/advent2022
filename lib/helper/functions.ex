defmodule Helper.Functions do
  def par_map(enumerable, func) do
    enumerable
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await(&1))
  end
end

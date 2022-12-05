defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack ->
      with {:ok, compartments} <- split_in_half(rucksack),
           rucksack_sets <- Enum.map(compartments, &MapSet.new(String.split(&1, "", trim: true))) do
        Sets.intersection(rucksack_sets)
      end
    end)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.map(&Priority.value_from_list/1)
    |> Enum.sum()
  end

  defp split_in_half(rucksack) do
    rucksack_size = String.length(rucksack)

    first_part = String.slice(rucksack, 0..(div(rucksack_size, 2) - 1))
    second_part = String.slice(rucksack, div(rucksack_size, 2)..(rucksack_size - 1))

    cond do
      String.length(first_part) != String.length(second_part) ->
        {:error, "Lengths are not equal"}

      first_part <> second_part !== rucksack ->
        {:error, "String were not broken into two equal parts"}

      true ->
        {:ok, [first_part, second_part]}
    end
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(fn rucksack_groups ->
      rucksack_groups
      |> Enum.map(fn group ->
        characters = String.split(group, "", trim: true)
        MapSet.new(characters)
      end)
      |> Sets.intersection()
    end)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.map(&Priority.value_from_list/1)
    |> Enum.sum()
  end
end

defmodule Sets do
  def intersection(sets) do
    Enum.reduce(sets, fn set, acc ->
      MapSet.intersection(set, acc)
    end)
  end
end

defmodule Priority do
  @alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)

  def value_from_list([letter]) do
    index = Enum.find_index(@alphabet, fn x -> x === letter end)

    if index == nil do
      raise("Letter not found in alphabet")
    else
      index + 1
    end
  end

  def value_from_list(_), do: raise("Expected a list of one element")
end

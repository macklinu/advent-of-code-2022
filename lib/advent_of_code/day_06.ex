defmodule AdventOfCode.Day06 do
  def part1(input) do
    characters = to_character_array(input)
    marker_detector = create_marker_detector(marker_length: 4)

    Enum.reduce_while(
      characters,
      %{seen: [], index: 0},
      fn character, acc -> marker_detector.(character, acc) end
    )
  end

  defp create_marker_detector(marker_length: marker_length),
    do: fn character, acc ->
      if MapSet.size(MapSet.new(acc.seen)) == marker_length do
        {:halt, acc.index}
      else
        remove_from_front = length(acc.seen) == marker_length

        {:cont,
         %{
           acc
           | seen: append_to_list(acc.seen, character, remove_from_front: remove_from_front),
             index: acc.index + 1
         }}
      end
    end

  defp append_to_list(list, character, remove_from_front: true),
    do: Enum.slice(list, 1..-1) ++ [character]

  defp append_to_list(list, character, remove_from_front: false), do: list ++ [character]

  defp to_character_array(string) do
    String.trim(string)
    |> String.split("", trim: true)
  end

  def part2(input) do
    characters = to_character_array(input)
    marker_detector = create_marker_detector(marker_length: 14)

    Enum.reduce_while(
      characters,
      %{seen: [], index: 0},
      fn character, acc -> marker_detector.(character, acc) end
    )
  end
end

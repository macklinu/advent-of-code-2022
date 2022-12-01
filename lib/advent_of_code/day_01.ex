defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.max()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn s -> Enum.map(s, &String.to_integer/1) end)
  end
end

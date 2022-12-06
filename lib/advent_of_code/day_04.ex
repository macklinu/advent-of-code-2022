defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_ranges()
    |> Enum.filter(fn [from, to] ->
      Enum.all?(from, fn value -> value in to end) || Enum.all?(to, fn value -> value in from end)
    end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> parse_ranges()
    |> Enum.filter(fn [from, to] ->
      Enum.any?(from, fn value -> value in to end) || Enum.any?(to, fn value -> value in from end)
    end)
    |> Enum.count()
  end

  @spec parse_ranges(binary()) :: [Range.t()]
  defp parse_ranges(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn string ->
      range_parts = String.split(string, ",")
      Enum.map(range_parts, &to_range/1)
    end)
  end

  @spec to_range(String.t()) :: Range.t()
  defp to_range(string) do
    [from, to] = String.split(string, "-") |> Enum.map(&String.to_integer/1)
    from..to
  end
end

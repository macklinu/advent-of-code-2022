defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = AdventOfCode.Input.get!(2, 2022)
    result = part1(input)

    assert result == 11666
  end

  test "part2" do
    input = AdventOfCode.Input.get!(2, 2022)
    result = part2(input)

    assert result == 12767
  end
end

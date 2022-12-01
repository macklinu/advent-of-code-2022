defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input AdventOfCode.Input.get!(1, 2022)

  test "part1" do
    result = part1(@input)

    assert result == 67633
  end

  test "part2" do
    result = part2(@input)

    assert result == 199_628
  end
end

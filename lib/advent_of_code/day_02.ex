defmodule AdventOfCode.Day02 do
  def part1(input), do: RockPaperScissorsPartOne.total_score(input)

  def part2(input), do: RockPaperScissorsPartTwo.total_score(input)
end

defmodule RockPaperScissorsPartOne do
  def total_score(input), do: parse(input) |> calculate_score()

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_move/1)
  end

  defp calculate_score(moves) do
    moves
    |> Enum.map(fn move ->
      with {_, my_move} <- move,
           result <- outcome(move),
           outcome_score <- OutcomeScore.calculate(result),
           choice_score <- ChoiceScore.calculate(my_move) do
        outcome_score + choice_score
      end
    end)
    |> Enum.sum()
  end

  defp parse_move(line) do
    with their_move <- String.at(line, 0) |> to_move_type(),
         my_move <- String.at(line, 2) |> to_move_type() do
      {their_move, my_move}
    end
  end

  defp to_move_type(move) when move in ["A", "X"], do: :rock
  defp to_move_type(move) when move in ["B", "Y"], do: :paper
  defp to_move_type(move) when move in ["C", "Z"], do: :scissors
  defp to_move_type(move), do: raise("Invalid move type: #{move}")

  defp outcome({a, b}) when a == b, do: :draw
  defp outcome({:rock, :scissors}), do: :loss
  defp outcome({:paper, :rock}), do: :loss
  defp outcome({:scissors, :paper}), do: :loss
  defp outcome({:rock, :paper}), do: :win
  defp outcome({:paper, :scissors}), do: :win
  defp outcome({:scissors, :rock}), do: :win
  defp outcome(move), do: raise("Unknown move combination: #{move}")
end

defmodule RockPaperScissorsPartTwo do
  def total_score(input), do: parse(input) |> calculate_score()

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_move/1)
  end

  defp calculate_score(moves) do
    moves
    |> Enum.map(fn move ->
      with {_, result} = move,
           my_move = determine_my_move(move),
           outcome_score <- OutcomeScore.calculate(result),
           choice_score <- ChoiceScore.calculate(my_move) do
        outcome_score + choice_score
      end
    end)
    |> Enum.sum()
  end

  defp parse_move(line) do
    with their_move <- String.at(line, 0) |> to_move_type(),
         result <- String.at(line, 2) |> to_result_type() do
      {their_move, result}
    end
  end

  defp to_move_type("A"), do: :rock
  defp to_move_type("B"), do: :paper
  defp to_move_type("C"), do: :scissors
  defp to_move_type(move), do: raise("Invalid move type: #{move}")

  defp to_result_type("X"), do: :loss
  defp to_result_type("Y"), do: :draw
  defp to_result_type("Z"), do: :win
  defp to_result_type(result), do: raise("Invalid result: #{result}")

  defp determine_my_move({move, :draw}), do: move
  defp determine_my_move({:rock, :win}), do: :paper
  defp determine_my_move({:scissors, :loss}), do: :paper
  defp determine_my_move({:paper, :win}), do: :scissors
  defp determine_my_move({:rock, :loss}), do: :scissors
  defp determine_my_move({:scissors, :win}), do: :rock
  defp determine_my_move({:paper, :loss}), do: :rock
  defp determine_my_move(move), do: raise("Unknown move: #{move}")
end

defmodule ChoiceScore do
  def calculate(:rock), do: 1
  def calculate(:paper), do: 2
  def calculate(:scissors), do: 3
  def calculate(choice), do: raise("Invalid choice: #{choice}")
end

defmodule OutcomeScore do
  def calculate(:win), do: 6
  def calculate(:draw), do: 3
  def calculate(:loss), do: 0
  def calculate(outcome), do: raise("Invalid outcome: #{outcome}")
end

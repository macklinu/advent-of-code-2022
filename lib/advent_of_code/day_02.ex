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
           {:ok, result} <- outcome(move),
           {:ok, outcome_score} <- OutcomeScore.calculate(result),
           {:ok, choice_score} <- ChoiceScore.calculate(my_move) do
        outcome_score + choice_score
      end
    end)
    |> Enum.sum()
  end

  defp parse_move(line) do
    with {:ok, their_move} <- String.at(line, 0) |> to_move_type(),
         {:ok, my_move} <- String.at(line, 2) |> to_move_type() do
      {their_move, my_move}
    end
  end

  defp to_move_type(move) when move in ["A", "X"], do: {:ok, :rock}
  defp to_move_type(move) when move in ["B", "Y"], do: {:ok, :paper}
  defp to_move_type(move) when move in ["C", "Z"], do: {:ok, :scissors}
  defp to_move_type(move), do: {:error, "Invalid move type: #{move}"}

  defp outcome({a, b}) when a == b, do: {:ok, :draw}
  defp outcome({:rock, :scissors}), do: {:ok, :loss}
  defp outcome({:paper, :rock}), do: {:ok, :loss}
  defp outcome({:scissors, :paper}), do: {:ok, :loss}
  defp outcome({:rock, :paper}), do: {:ok, :win}
  defp outcome({:paper, :scissors}), do: {:ok, :win}
  defp outcome({:scissors, :rock}), do: {:ok, :win}
  defp outcome(move), do: {:error, "Unknown move combination: #{move}"}
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
           {:ok, outcome_score} <- OutcomeScore.calculate(result),
           {:ok, choice_score} <- ChoiceScore.calculate(my_move) do
        outcome_score + choice_score
      end
    end)
    |> Enum.sum()
  end

  defp parse_move(line) do
    with {:ok, their_move} <- String.at(line, 0) |> to_move_type(),
         {:ok, result} <- String.at(line, 2) |> to_result_type() do
      {their_move, result}
    end
  end

  defp to_move_type("A"), do: {:ok, :rock}
  defp to_move_type("B"), do: {:ok, :paper}
  defp to_move_type("C"), do: {:ok, :scissors}
  defp to_move_type(move), do: {:error, "Invalid move type: #{move}"}

  defp to_result_type("X"), do: {:ok, :loss}
  defp to_result_type("Y"), do: {:ok, :draw}
  defp to_result_type("Z"), do: {:ok, :win}
  defp to_result_type(result), do: {:error, "Invalid result: #{result}"}

  defp determine_my_move({move, :draw}), do: move
  defp determine_my_move({:rock, :win}), do: :paper
  defp determine_my_move({:scissors, :loss}), do: :paper
  defp determine_my_move({:paper, :win}), do: :scissors
  defp determine_my_move({:rock, :loss}), do: :scissors
  defp determine_my_move({:scissors, :win}), do: :rock
  defp determine_my_move({:paper, :loss}), do: :rock
  defp determine_my_move(move), do: {:error, "Unknown move: #{move}"}
end

defmodule ChoiceScore do
  def calculate(:rock), do: {:ok, 1}
  def calculate(:paper), do: {:ok, 2}
  def calculate(:scissors), do: {:ok, 3}
  def calculate(choice), do: {:error, "Invalid choice: #{choice}"}
end

defmodule OutcomeScore do
  def calculate(:win), do: {:ok, 6}
  def calculate(:draw), do: {:ok, 3}
  def calculate(:loss), do: {:ok, 0}
  def calculate(outcome), do: {:error, "Invalid outcome: #{outcome}"}
end

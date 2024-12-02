defmodule Report do
  def safe?([first | [second | _] = rest]) do
    # Determine initial direction from first two numbers
    direction = if second > first, do: :increasing, else: :decreasing
    check_sequence([first | rest], direction)
  end

  # Helper to check the full sequence
  defp check_sequence([_last], _direction), do: true

  defp check_sequence([a, b | rest], direction) do
    diff = b - a

    cond do
      # Must be between 1-3
      abs(diff) < 1 or abs(diff) > 3 -> false
      # For increasing sequences, diff must be positive
      direction == :increasing and diff <= 0 -> false
      # For decreasing sequences, diff must be negative
      direction == :decreasing and diff >= 0 -> false
      # Continue checking rest of sequence
      true -> check_sequence([b | rest], direction)
    end
  end
end

# Read and process input
File.stream!("input.txt")
|> Stream.map(&String.split(&1, " "))
|> Stream.map(fn x -> Enum.map(x, &String.trim/1) end)
|> Stream.map(fn x -> Enum.map(x, &String.to_integer/1) end)
|> Stream.filter(&Report.safe?/1)
|> Enum.count()
|> IO.inspect()
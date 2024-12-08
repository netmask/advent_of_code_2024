defmodule XMAS do
  @directions [
    # right
    {0, 1},
    # left
    {0, -1},
    # down
    {1, 0},
    # up
    {-1, 0},
    # diagonal down-right
    {1, 1},
    # diagonal up-left
    {-1, -1},
    # diagonal down-left
    {1, -1},
    # diagonal up-right
    {-1, 1}
  ]

  def count_xmas(grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        direction <- @directions,
        check_xmas(grid, {row, col}, direction),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  defp check_xmas(grid, {row, col}, {dx, dy}) do
    positions = for i <- 0..3, do: {row + i * dx, col + i * dy}

    with true <- Enum.all?(positions, &valid_position?(&1, grid)),
         chars = Enum.map(positions, &get_char(grid, &1)),
         word = Enum.join(chars) do
      word == "XMAS"
    else
      _ -> false
    end
  end

  defp valid_position?({row, col}, grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))
    row >= 0 and row < rows and col >= 0 and col < cols
  end

  defp get_char(grid, {row, col}) do
    grid
    |> Enum.at(row)
    |> Enum.at(col)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end
end

# Read and process input
File.read!("input.txt")
|> XMAS.parse_input()
|> XMAS.count_xmas()
|> IO.puts()

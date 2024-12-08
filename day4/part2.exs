defmodule XMAS do
  @mas "MAS"
  @sam "SAM"

  def count_x_mas(grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    for row <- 1..(rows - 2),
        col <- 1..(cols - 2) do
      check_x_pattern(grid, {row, col})
    end
    |> Enum.sum()
  end

  defp check_x_pattern(grid, {row, col}) do
    diagonals = [
      get_diagonal(grid, {row - 1, col - 1}, {1, 1}),
      get_diagonal(grid, {row + 1, col - 1}, {-1, 1}),
      get_diagonal(grid, {row - 1, col + 1}, {1, -1}),
      get_diagonal(grid, {row + 1, col + 1}, {-1, -1})
    ]

    check_diagonal_combinations(diagonals)
  end

  defp get_diagonal(grid, {start_row, start_col}, {row_dir, col_dir}) do
    for i <- 0..2,
        row = start_row + i * row_dir,
        col = start_col + i * col_dir,
        row >= 0 and row < length(grid),
        col >= 0 and col < length(Enum.at(grid, 0)) do
      get_char(grid, {row, col})
    end
  end

  defp check_diagonal_combinations([d1, d2, d3, d4]) do
    combinations = [
      {d1, d3},
      {d2, d4}
    ]

    if Enum.any?(combinations, &valid_x_pattern?/1), do: 1, else: 0
  end

  defp valid_x_pattern?({diag1, diag2}) do
    String.length(to_string(diag1)) == 3 and
      String.length(to_string(diag2)) == 3 and
      (is_mas?(Enum.join(diag1)) and is_mas?(Enum.join(diag2)))
  end

  defp is_mas?(str) do
    str == @mas or str == @sam
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
|> XMAS.count_x_mas()
|> IO.puts()

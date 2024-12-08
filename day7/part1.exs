defmodule Calculator do
  @operations [
    &Calculator.add/2,
    &Calculator.multiply/2
  ]

  def add(a, b), do: a + b
  def multiply(a, b), do: a * b

  def polish_notation_ops([]), do: 0
  def polish_notation_ops([last]), do: last

  def polish_notation_ops([first | rest]) do
    for operation <- @operations do
      {operation, first, polish_notation_ops(rest)}
    end
  end

  def is_valid(operations, total) do
    process_path(operations) |> List.flatten() |> Enum.find(fn x -> x == total end)
  end

  def process_path(x) when is_integer(x), do: x

  def process_path(path) do
    Enum.map(path, fn operation ->
      case operation do
        {_, _, _} -> execute_operation(operation)
        x when is_list(x) -> x
        x -> x
      end
    end)
  end

  def execute_operation(path) when is_integer(path), do: path

  def execute_operation({operation, a, path}) when is_list(path) do
    process_path(path)
    |> Enum.map(fn b -> execute_operation({operation, a, b}) end)
  end

  def execute_operation({operation, a, b}) do
    operation.(a, b)
  end
end

File.stream!("input.txt")
|> Stream.map(&String.trim(&1))
|> Stream.map(&String.split(&1, ":"))
|> Enum.map(fn [total, terms] ->
  with total <- String.to_integer(total),
       terms <-
         terms
         |> String.trim()
         |> String.split(" ")
         |> Enum.map(&String.to_integer/1)
         |> Enum.reverse() do
    Calculator.polish_notation_ops(terms)
    |> Calculator.is_valid(total)
  end
end)
|> Enum.filter(& &1)
|> Enum.sum()
|> IO.inspect()

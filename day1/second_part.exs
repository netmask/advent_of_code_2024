File.stream!("input.txt")
|> Stream.map(&String.split(&1, "  "))
|> Enum.reduce([[], []], fn row, acc ->
  row
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)
  |> then(fn [first, second] -> [[first | Enum.at(acc, 0)], [second | Enum.at(acc, 1)]] end)
end)
|> Enum.map(&Enum.sort/1)
|> then(fn [first, second] ->
  with group <-
         Enum.group_by(second, & &1)
         |> Enum.map(fn {key, values} -> {key, Enum.count(values)} end)
         |> Enum.into(%{}) do
    first
    |> Enum.map(fn x -> x * Map.get(group, x, 0) end)
    |> Enum.sum()
  end
end)
|> IO.inspect()

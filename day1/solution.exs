File.stream!("input.txt")
|> Stream.map(&String.split(&1, "  "))
|> Enum.reduce([[], []], fn row, acc ->
  row
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.to_integer/1)
  |> then(fn [first, second] -> [[first | Enum.at(acc, 0)], [second | Enum.at(acc, 1)]] end)
end)
|> Enum.map(&Enum.sort/1)
|> List.zip()
|> Enum.map(fn {first, second} -> abs(first - second) end)
|> Enum.sum()
|> IO.inspect()

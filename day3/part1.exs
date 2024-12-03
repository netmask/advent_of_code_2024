defmodule AST do
  def parse(line, ast \\ []) do
    case line do
      <<"mul(", rest::binary>> ->
        {content, rest} = args(rest)

        parse(rest, [{:mult, content} | ast])

      <<_head::binary-size(1), rest::binary>> ->
        parse(rest, ast)

      _ ->
        ast
    end
  end

  def args(line, content \\ []) do
    case line do
      <<")", rest::binary>> ->
        {Enum.reverse(content), rest}

      <<",", rest::binary>> ->
        args(rest, [:comma | content])

      <<el::binary-size(1), rest::binary>> ->
        case el do
          el when el in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
            args(rest, [el | content])

          _ ->
            {:invalid_exp, rest}
        end

      _ ->
        {:no_clossing, line}
    end
  end
end

defmodule Exec do
  def process(list) do
    for {:mult, content} <- list do
      execute(content)
    end
  end

  def execute(:invalid_exp), do: 0

  def execute(content) do
    left = Enum.take_while(content, fn x -> x != :comma end) |> Enum.join()
    right = Enum.drop_while(content, fn x -> x != :comma end) |> Enum.drop(1) |> Enum.join()
    String.to_integer(left) * String.to_integer(right)
  end
end

File.read!("input.txt")
|> AST.parse()
|> Exec.process()
|> Enum.sum()
|> IO.inspect(label: "result")

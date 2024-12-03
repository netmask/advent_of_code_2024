defmodule AST do
  def parse(line, ast \\ []) do
    case line do
      <<"mul(", rest::binary>> ->
        case args(rest) do
          {:invalid_exp, rest} -> parse(rest, [:invalid_exp | ast])
          {:no_clossing, rest} -> parse(rest, [:invalid_exp | ast])
          {content, rest} -> parse(rest, [{:mult, content} | ast])
        end

      <<"do()", rest::binary>> ->
        parse(rest, [:execute_next | ast])

      <<"don't()", rest::binary>> ->
        parse(rest, [:skip_next | ast])

      <<_head::binary-size(1), rest::binary>> ->
        parse(rest, ast)

      _ ->
        Enum.reverse(ast)
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
    {result, _} =
      Enum.filter(list, fn x -> x != :invalid_exp end)
      |> Enum.reduce({0, :execute}, fn
        {:mult, content}, {acc, :execute} -> {acc + execute(content), :execute}
        {:mult, _content}, {acc, :skip_next} -> {acc, :skip_next}
        :execute_next, {acc, _state} -> {acc, :execute}
        :skip_next, {acc, _state} -> {acc, :skip_next}
      end)

    result
  end

  def execute(content) do
    # ewww this is ugly
    left = Enum.take_while(content, fn x -> x != :comma end) |> Enum.join()
    right = Enum.drop_while(content, fn x -> x != :comma end) |> Enum.drop(1) |> Enum.join()
    String.to_integer(left) * String.to_integer(right)
  end
end

File.read!("input.txt")
|> AST.parse()
|> Exec.process()
|> IO.inspect()

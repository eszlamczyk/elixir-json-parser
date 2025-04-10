# S := value
# value      := object | array | string | number | "true" | "false" | "null"
# object     := "{" [pair ("," pair)*] "}"
# pair       := string ":" value
# array      := "[" [value ("," value)*] "]"

defmodule JSONParser do
  alias JSONTokenizer

  def parse(string) do
    tokens = JSONTokenizer.tokenize(string)
    parse_value(tokens)
  end

  defp parse_value([false | rest]), do: {rest, false}
  defp parse_value([true | rest]), do: {rest, true}
  defp parse_value([:null | rest]), do: {rest, nil}
  defp parse_value([{:number, num} | rest]), do: {rest, num}
  defp parse_value([{:string, str} | rest]), do: {rest, str}

  # zparsuj pare, potem wywołaj funkcje która sprawdza czy jest , czy } i albo kontynuuj rekursje albo zwróć
  defp parse_value([:left_bracket | rest]) do
    parse_object(rest, [])
  end

  defp parse_object(tokens, []) do
    parse_pair(tokens)
  end

  defp parse_pair(tokens), do: parse_pair_string(tokens)

  defp parse_pair_string([{:string, str} | rest]), do: parse_pair_colon(rest, str)
  defp parse_pair_string([tok | _rest]), do: raise("Unexpected token #{tok}")

  defp parse_pair_colon([:colon | rest], str), do: parse_pair_value(rest, str)
  defp parse_pair_colon([tok | _rest], _str), do: raise("Unexpected token #{tok}")

  defp parse_pair_value(tokens, str), do: {str, parse_value(tokens)}
end

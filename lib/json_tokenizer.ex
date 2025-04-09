defmodule JSONTokenizer do
  alias NumberTokenizer
  alias StringTokenizer

  def tokenize(string), do: tokenize(string, [])

  defp tokenize(<<>>, acc), do: Enum.reverse(acc)

  # skip whitespace
  defp tokenize(<<char::utf8, rest::binary>>, acc) when char in ~c' \n\r\t' do
    tokenize(rest, acc)
  end

  defp tokenize(<<"{", rest::binary>>, acc), do: tokenize(rest, [:left_brace | acc])
  defp tokenize(<<"}", rest::binary>>, acc), do: tokenize(rest, [:right_brace | acc])
  defp tokenize(<<"[", rest::binary>>, acc), do: tokenize(rest, [:left_bracket | acc])
  defp tokenize(<<"]", rest::binary>>, acc), do: tokenize(rest, [:right_bracket | acc])
  defp tokenize(<<":", rest::binary>>, acc), do: tokenize(rest, [:colon | acc])
  defp tokenize(<<",", rest::binary>>, acc), do: tokenize(rest, [:comma | acc])
  defp tokenize(<<"null", rest::binary>>, acc), do: tokenize(rest, [:null | acc])
  defp tokenize(<<"false", rest::binary>>, acc), do: tokenize(rest, [false | acc])
  defp tokenize(<<"true", rest::binary>>, acc), do: tokenize(rest, [true | acc])

  defp tokenize(<<char::utf8, rest::binary>>, acc) when char in ~c'-0123456789' do
    {number_string, new_rest} = NumberTokenizer.tokenize_number(<<char::utf8, rest::binary>>)

    number =
      if String.contains?(number_string, [".", "e", "E"]) do
        String.to_float(number_string)
      else
        String.to_integer(number_string)
      end

    tokenize(new_rest, [{:number, number} | acc])
  end

  defp tokenize(<<"\"", rest::binary>>, acc) do
    {result, new_rest} = StringTokenizer.tokenize_string(rest)

    tokenize(new_rest, [{:string, result} | acc])
  end

  defp tokenize(<<rest::binary>>, _acc) do
    raise "Unexpected character: #{inspect(rest)}"
  end
end

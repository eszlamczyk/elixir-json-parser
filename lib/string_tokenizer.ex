defmodule StringTokenizer do
  def tokenize_string(str), do: tokenize_string(str, <<>>)

  defp tokenize_string(<<"\"", rest::binary>>, acc), do: {acc, rest}

  defp tokenize_string(<<char::utf8, rest::binary>>, acc),
    do: tokenize_string(rest, <<acc::binary, char::utf8>>)

  defp tokenize_string(<<>>, _acc) do
    raise "Unterminated string"
  end
end

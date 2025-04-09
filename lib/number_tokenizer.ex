defmodule NumberTokenizer do
  # public call
  def tokenize_number(string) do
    tokenize_begining(string)
  end

  # begining of whole number: negative/positive
  defp tokenize_begining(<<"-", rest::binary>>), do: tokenize_number_begining(rest, "-")

  defp tokenize_begining(str), do: tokenize_number_begining(str, "")

  # begining of whole part of number
  defp tokenize_number_begining(<<"0.", rest::binary>>, acc),
    do: tokenize_fraction_begining(rest, <<acc::binary, "0.">>)

  defp tokenize_number_begining(<<char::utf8, rest::binary>>, acc) when char in ~c'123456789' do
    tokenize_number(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_number_begining(_str, _acc) do
    raise "No number after minus sign"
  end

  # whole part of number
  defp tokenize_number(<<char::utf8, rest::binary>>, acc) when char in ~c'0123456789' do
    tokenize_number(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_number(<<".", rest::binary>>, acc) do
    tokenize_fraction_begining(rest, <<acc::binary, ".">>)
  end

  defp tokenize_number(<<char::utf8, rest::binary>>, acc) when char in ~c'eE' do
    tokenize_exponent_begining(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_number(<<char::utf8, rest::binary>>, acc) when char in ~c' \n\r\t,' do
    {acc, rest}
  end

  defp tokenize_number(<<>>, acc), do: {acc, <<>>}

  defp tokenize_number(_str, _acc) do
    raise "Invalid character in number"
  end

  # fraction, first digit
  defp tokenize_fraction_begining(<<char::utf8, rest::binary>>, acc)
       when char in ~c'0123456789' do
    tokenize_fraction(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_fraction_begining(_str, _acc) do
    raise "Unterminated fractional number"
  end

  # fraction second and next digit
  defp tokenize_fraction(<<char::utf8, rest::binary>>, acc) when char in ~c'0123456789' do
    tokenize_fraction(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_fraction(<<char::utf8, rest::binary>>, acc) when char in ~c'eE' do
    tokenize_exponent_begining(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_fraction(<<char::utf8, rest::binary>>, acc) when char in ~c' \n\r\t,' do
    {acc, rest}
  end

  defp tokenize_fraction(<<>>, acc), do: {acc, <<>>}

  defp tokenize_fraction(<<char::utf8, _rest::binary>>, _acc) do
    raise "Unexpected character in number fraction #{char}"
  end

  # exponent part of number
  defp tokenize_exponent_begining(<<char::utf8, rest::binary>>, acc)
       when char in ~c'+-0123456789' do
    tokenize_exponent(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_exponent(<<char::utf8, rest::binary>>, acc) when char in ~c'0123456789' do
    tokenize_exponent(rest, <<acc::binary, char::utf8>>)
  end

  defp tokenize_exponent(<<char::utf8, rest::binary>>, acc) when char in ~c' \n\r\t,' do
    {acc, rest}
  end

  defp tokenize_exponent(<<>>, acc), do: {acc, <<>>}

  defp tokenize_exponent(_str, _acc) do
    raise "Unexpected character in number exponent"
  end
end

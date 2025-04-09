defmodule JSONStringifier do
  @spec stringify(any()) :: binary()
  def stringify(val) do
    value_to_string(val)
  end

  defp list_to_string(list) do
    stringified =
      list
      |> Enum.map_join(",", fn elem -> value_to_string(elem) end)

    "[" <> stringified <> "]"
  end

  defp key_to_string(key) do
    cond do
      is_atom(key) -> "\"" <> Atom.to_string(key) <> "\""
      true -> "\"" <> key <> "\""
    end
  end

  defp object_to_string(object) when is_map(object) do
    stringified =
      object
      |> Enum.map_join(",", fn {key, val} ->
        key_to_string(key) <> ":" <> value_to_string(val)
      end)

    "{" <> stringified <> "}"
  end

  defp object_to_string(_object) do
    # error moment
    "object"
  end

  defp number_to_string(number) when is_integer(number) do
    Integer.to_string(number)
  end

  defp number_to_string(number) when is_float(number) do
    Float.to_string(number)
  end

  defp value_to_string(value) do
    cond do
      is_boolean(value) && value -> "true"
      is_boolean(value) && !value -> "false"
      is_nil(value) -> "null"
      is_list(value) -> list_to_string(value)
      is_number(value) -> number_to_string(value)
      is_binary(value) -> "\"" <> value <> "\""
      is_atom(value) -> "\"" <> Atom.to_string(value) <> "\""
      true -> object_to_string(value)
    end
  end
end

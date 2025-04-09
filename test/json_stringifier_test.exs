defmodule JSONStringifierTest do
  use ExUnit.Case
  doctest JSONStringifier

  test "value to string" do
    assert JSONStringifier.stringify(nil) === "null", "JSONStringifier.stringify(:nil) === \"null\" failed"
    assert JSONStringifier.stringify(nil) === "null"
    assert JSONStringifier.stringify(false) === "false"
    assert JSONStringifier.stringify(true) === "true"
    assert JSONStringifier.stringify(false) === "false"
    assert JSONStringifier.stringify(true) === "true"
    assert JSONStringifier.stringify("nil") === "\"nil\""
    assert JSONStringifier.stringify("null") === "\"null\""
    assert JSONStringifier.stringify("false") === "\"false\""
    assert JSONStringifier.stringify("true") === "\"true\""
    assert JSONStringifier.stringify("string") === "\"string\""
    assert JSONStringifier.stringify("string with spaces") === "\"string with spaces\""
    assert JSONStringifier.stringify("") === "\"\""
    assert JSONStringifier.stringify(10) === "10"
    assert JSONStringifier.stringify(4.1) === "4.1"
    assert JSONStringifier.stringify(1.0e12) === "1.0e12"
    assert JSONStringifier.stringify(1.0E-12) === "1.0e-12"
    assert JSONStringifier.stringify(0.00000000001) === "1.0e-11"
    assert JSONStringifier.stringify(:atom) === "\"atom\""
    assert JSONStringifier.stringify(:"1atom") === "\"1atom\""
  end

  test "array to string" do
    assert JSONStringifier.stringify(["1", :"2", 3, 4.1, :five, false, false, true, true, nil, nil]) ===
             "[\"1\",\"2\",3,4.1,\"five\",false,false,true,true,null,null]"

    assert JSONStringifier.stringify([]) === "[]"
  end
end

defmodule JsonParserTest do
  use ExUnit.Case
  doctest JsonParser

  test "empty to string" do
    assert JsonParser.stringify() === nil
  end

  test "value to string" do
    assert JsonParser.stringify(nil) === "null", "JsonParser.stringify(:nil) === \"null\" failed"
    assert JsonParser.stringify(nil) === "null"
    assert JsonParser.stringify(false) === "false"
    assert JsonParser.stringify(true) === "true"
    assert JsonParser.stringify(false) === "false"
    assert JsonParser.stringify(true) === "true"
    assert JsonParser.stringify("nil") === "\"nil\""
    assert JsonParser.stringify("null") === "\"null\""
    assert JsonParser.stringify("false") === "\"false\""
    assert JsonParser.stringify("true") === "\"true\""
    assert JsonParser.stringify("string") === "\"string\""
    assert JsonParser.stringify("string with spaces") === "\"string with spaces\""
    assert JsonParser.stringify("") === "\"\""
    assert JsonParser.stringify(10) === "10"
    assert JsonParser.stringify(4.1) === "4.1"
    assert JsonParser.stringify(1.0e12) === "1.0e12"
    # assert JsonParser.stringify(1.0e-12) === "1.0E-12"
    # assert JsonParser.stringify(1.0e2) === "1.0E2"
    assert JsonParser.stringify(:atom) === "\"atom\""
    assert JsonParser.stringify(:"1atom") === "\"1atom\""
  end

  test "array to string" do
    assert JsonParser.stringify(["1", :"2", 3, 4.1, :five, false, false, true, true, nil, nil]) ===
             "[\"1\",\"2\",3,4.1,\"five\",false,false,true,true,null,null]"

    assert JsonParser.stringify([]) === "[]"
  end
end

defmodule StanCodeTest do
  use ExUnit.Case

  @encoded_code "MjQ0Mjk6MjoxMzg"

  test "decoding an encoded code" do
    result = StanCode.decode(@encoded_code)
    assert result[:campaign] == "24429"
    assert result[:program] == "2"
    assert result[:site] == "138"
  end
end

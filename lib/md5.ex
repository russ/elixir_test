defmodule MD5 do
  def hash(nil) do
    hash("")
  end

  def hash(s) do
    :crypto.hash(:md5, s)
    |> :erlang.bitstring_to_list
    |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
    |> List.flatten
    |> :erlang.list_to_bitstring
  end
end

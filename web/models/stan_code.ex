defmodule Bouncer.StanCode do
  defstruct site: "0", program: "0", campaign: "0"

  def to_string(code) do
    "1234567890"
  end

  def decode(string) do
    decode_encoded_code(string)
  end

  defp decode_encoded_code(string) do
    result = fix_encoded_code(string)
             |> :base64.decode
             |> String.split(":")

    %Bouncer.StanCode{
      campaign: Enum.at(result, 0),
      program: Enum.at(result, 1),
      site: Enum.at(result, 2),
    }
  end

  defp fix_encoded_code(string) do
    length = String.length(string)
    append = fn
      (append, string, 0) -> string
      (append, string, count) ->
        append.(append, string <> "=", count - 1)
    end
    append.(append, string, (4 - rem(length, 4)))
  end
end

defmodule Bouncer.StanCode do
  @moduledoc """
    Module to encode/decode/inspect stan codes.
  """

  defstruct encoded: true, code: "",
            site: "0", program: "0", campaign: "0",
            username: "", tour: "", sub_id_1: "", sub_id_2: "", ad_id: ""

  @doc """
    Encodes a encoded StanCode map into a string.
  """
  def encode(map = %Bouncer.StanCode{encoded: true}) do
    cleanup_code_string("#{map.code},#{map.tour},#{map.sub_id_1},#{map.sub_id_2},#{map.ad_id}")
  end

  @doc """
    Encodes a unencoded StanCode map wthout a campaign present into a string.
  """
  def encode(map = %Bouncer.StanCode{encoded: false, campaign: ""}) do
    cleanup_code_string("#{map.username}:#{map.program}:#{map.site},#{map.tour},#{map.sub_id_1},#{map.sub_id_2},#{map.ad_id}")
  end

  @doc """
    Encodes a unencoded StanCode map wthout a campaign present into a string.
  """
  def encode(map = %Bouncer.StanCode{encoded: false, campaign: "0"}) do
    cleanup_code_string("#{map.username}:#{map.program}:#{map.site},#{map.tour},#{map.sub_id_1},#{map.sub_id_2},#{map.ad_id}")
  end

  @doc """
    Encodes a unencoded StanCode map wth a campaign present into a string.
  """
  def encode(map = %Bouncer.StanCode{encoded: false}) do
    cleanup_code_string("#{map.username};#{map.campaign}:#{map.program}:#{map.site},#{map.tour},#{map.sub_id_1},#{map.sub_id_2},#{map.ad_id}")
  end

  @doc """
    Decodes a string into a StanCode map.
  """
  def decode(string) do
    data = String.split(string, ";;")
    code = hd(String.split(hd(data), ","))
    metadata = tl(String.split(hd(data), ","))

    map = if String.contains?(code, ":") do
      decode_unencoded_code(code)
    else
      decode_encoded_code(code)
    end

    assign_metadata(map, metadata)
  end


  # Private Methods

  defp decode_encoded_code(string) do
    result = fix_encoded_code(string)
             |> :base64.decode
             |> String.split(":")

    %Bouncer.StanCode{
      encoded: true,
      code: string,
      campaign: Enum.at(result, 0),
      program: Enum.at(result, 1),
      site: Enum.at(result, 2),
    }
  end

  defp decode_unencoded_code(string) do
    result = String.split(string, ":")

    if String.contains?(Enum.at(result, 0), ";") do
      split = Enum.at(result, 0) |> String.split(";")
      username = Enum.at(split, 0)
      campaign = Enum.at(split, 1)
    else
      username = Enum.at(result, 0)
      campaign = ""
    end

    %Bouncer.StanCode{
      encoded: false,
      code: string,
      username: Enum.at(result, 0),
      campaign: campaign,
      program: Enum.at(result, 1),
      site: Enum.at(result, 2)
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

  defp cleanup_code_string(string) do
    Regex.replace(~r/,$/, Regex.replace(~r/,,+/, string, ","), "")
  end

  defp assign_metadata(map, metadata) do
    keys = [:tour, :sub_id_1, :sub_id_2, :ad_id]
    list = Enum.to_list(Enum.zip(keys, metadata))
    Enum.reduce(list, map, fn({k ,v}, struct) ->
      case k do
        :tour -> %{struct | tour: v}
        :sub_id_1 -> %{struct | sub_id_1: v}
        :sub_id_2 -> %{struct | sub_id_2: v}
        :ad_id -> %{struct | ad_id: v}
        _ -> struct
      end
    end)
  end
end

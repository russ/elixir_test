defmodule Bouncer.StanCodeTest do use ExUnit.Case
  @encoded_code "MjQ0Mjk6MjoxMzg"
  @code_map %Bouncer.StanCode{
    code: @encoded_code,
    site: "24429",
    program: "2",
    site: "138",
    campaign: "1",
    username: "cloudsplitter",
    tour: "1",
    sub_id_1: "1",
    sub_id_2: "1",
    ad_id: "1"
  }

  test "decoding a encoded code" do
    result = Bouncer.StanCode.decode("MjQ0Mjk6OTQ6MTA")
    assert result.campaign == "24429"
    assert result.program == "94"
    assert result.site == "10"

    result = Bouncer.StanCode.decode("MzE4MDY6MjoxMzQ")
    assert result.campaign == "31806"
    assert result.program == "2"
    assert result.site == "134"
  end

  test "decoding a encoded code with metadata" do
    result = Bouncer.StanCode.decode("MjQ0Mjk6OTQ6MTA,16")
    assert result.tour == "16"

    result = Bouncer.StanCode.decode("MjQ0Mjk6OTQ6MTA,16,4")
    assert result.sub_id_1 == "4"

    result = Bouncer.StanCode.decode("MjQ0Mjk6OTQ6MTA,16,4,3")
    assert result.sub_id_2 == "3"

    result = Bouncer.StanCode.decode("MjQ0Mjk6OTQ6MTA,16,4,3,2")
    assert result.ad_id == "2"
  end

  test "an invalid code" do
    result = Bouncer.StanCode.decode("NOSUCHCODE")
    assert result.code == "NOSUCHCODE"
  end

  test "decoding a unencoded code" do
    result = Bouncer.StanCode.decode("cloudsplitter:18yorevshare:castingcouchx")
    assert result.username == "cloudsplitter"
    assert result.program == "18yorevshare"
    assert result.site == "castingcouchx"
  end

  test "decoding a unencoded code with metadata" do
    result = Bouncer.StanCode.decode("cloudsplitter:18yorevshare:castingcouchx,16")
    assert result.tour == "16"

    result = Bouncer.StanCode.decode("cloudsplitter:18yorevshare:castingcouchx,16,4")
    assert result.sub_id_1 == "4"

    result = Bouncer.StanCode.decode("cloudsplitter:18yorevshare:castingcouchx,16,4,3")
    assert result.sub_id_2 == "3"

    result = Bouncer.StanCode.decode("cloudsplitter:18yorevshare:castingcouchx,16,4,3,2")
    assert result.ad_id == "2"

    result = Bouncer.StanCode.decode("cloudsplitter;485881:18yorevshare:castingcouchx,16,4,3,2")
    assert result.campaign == "485881"
  end

  test "encoding a encoded code" do
    result = Bouncer.StanCode.encode(@code_map)
    assert result == "MjQ0Mjk6MjoxMzg,1,1,1,1"

    map = %{@code_map | tour: "", sub_id_1: "", sub_id_2: "", ad_id: ""}
    result = Bouncer.StanCode.encode(map)
    assert result == "MjQ0Mjk6MjoxMzg"
  end

  test "encoding a unencoded code" do
    map = %{@code_map | encoded: false, campaign: "", program: "18yorevshare", site: "castingcouchx"}
    result = Bouncer.StanCode.encode(map)
    assert result == "cloudsplitter:18yorevshare:castingcouchx,1,1,1,1"

    map = %{@code_map | encoded: false, campaign: "12345", program: "18yorevshare", site: "castingcouchx"}
    result = Bouncer.StanCode.encode(map)
    assert result == "cloudsplitter;12345:18yorevshare:castingcouchx,1,1,1,1"
  end
end

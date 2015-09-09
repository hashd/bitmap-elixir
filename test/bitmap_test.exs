defmodule BitmapTest do
  use ExUnit.Case

  test "create bitmaps with size" do
    assert Bitmap.Binary.new(0) == <<>>
    assert Bitmap.Binary.new(25) == <<0, 0, 0, 0::size(1)>>
    assert Bitmap.Binary.new(32) == <<0, 0, 0, 0>>
    assert Bitmap.Binary.new(120) == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "create bitmaps with range" do
    assert Bitmap.Binary.new(0..0) == <<0::size(1)>>
    assert Bitmap.Binary.new(0..10) == <<0, 0::size(3)>>
    assert Bitmap.Binary.new(512..591) == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "create bitmaps with list" do
    small_list = List.duplicate(5, 25)
    big_list = List.duplicate(10, 160)

    assert Bitmap.Binary.new([]) == <<>>
    assert Bitmap.Binary.new(small_list) == <<0, 0, 0, 0::size(1)>>
    assert Bitmap.Binary.new(big_list) == <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                     0, 0, 0, 0, 0>>
  end
end

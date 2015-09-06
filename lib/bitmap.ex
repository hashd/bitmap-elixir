defmodule Bitmap do
  @moduledoc """
  Contains functions to create and work with a [bitmap](https://en.wikipedia.org/wiki/Bitmap)

  Bitmaps are also known as bit arrays, bit sets and is a fast space efficient 
  data structure for lookups

  The module has been designed to be pipe-friendly, so pipe 'em up
  """
  @set_bit   1
  @unset_bit 0

  @doc """
  Creates and returns a bitmap of size corresponding to the `argument` passed.

  If `argument` is
  - integer, size of bitmap is equal to the `argument`
  - range, size of bitmap is equal to the length of `argument`
  - list, size of bitmap is equal to the length of `argument`

  > Note: All bits are set to 0 by default

  ## Examples
      iex> Bitmap.new(400)
      <<0::size(400)>>
      iex> Bitmap.new([1,2,3,4,5])
      <<0::size(5)>>
      iex> Bitmap.new(1..25)
      <<0::size(25)>>
  """
  def new(argument)
  def new(size) when is_integer(size), do: <<0::size(size)>>
  def new(list) when is_list(list), do: new(length(list))
  def new(a..b), do: new(abs(b - a + 1))

  @doc """
  Returns the bit value at `index` in the bitmap

  ## Examples
      iex> bm = Bitmap.new(5)
      iex> Bitmap.at(bm, 2)
      0
      iex> bm = Bitmap.set(bm, 2)
      iex> Bitmap.at(bm, 2)
      1
  """
  def at(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    {_prefix, bit, _rest} = split_at(bitmap, index)
    bit
  end

  @doc """
  Sets the bit at `index` in the bitmap and returns the new bitmap

  Index can also have a value `:all` in which case all bits
  will be set like in set_all

  ## Examples
      iex> Bitmap.set(Bitmap.new(5), 3)
      <<2::size(5)>>
      iex> Bitmap.set(Bitmap.new(1..10), 2)
      <<32, 0::size(2)>>
  """
  def set(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    set_bit(bitmap, index, @set_bit)
  end
  def set(bitmap, :all), do: set_all(bitmap)

  @doc """
  Set all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> Bitmap.set_all(Bitmap.new(10))
      <<255, 3::size(2)>>
      iex> Bitmap.set_all(Bitmap.new(100))
      <<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 15::size(4)>>
  """
  def set_all(bitmap) do
    size = bit_size(bitmap)
    fill_binary(<<>>, size, 1)
  end

  @doc """
  Unsets the bit at `index` in the bitmap and returns the new bitmap. 

  Index can also have a value `:all` in which case all bits
  will be unset like in unset_all

  ## Examples
      iex> bm = Bitmap.new(10) |> Bitmap.set(4) |> Bitmap.set(8)
      iex> Bitmap.unset(bm, 4)
      <<0, 2::size(2)>>
      iex> Bitmap.unset(bm, 8)
      <<8, 0::size(2)>>
  """
  def unset(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    set_bit(bitmap, index, @unset_bit)
  end
  def unset(bitmap, :all), do: unset_all(bitmap)

  @doc """
  Unsets all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> bm = Bitmap.new(10) |> Bitmap.set(4) |> Bitmap.set(8)
      iex> Bitmap.unset_all(bm)
      <<0, 0::size(2)>>
  """
  def unset_all(bitmap) do
    size = bit_size(bitmap)
    fill_binary(<<>>, size, 0)
  end

  @doc """
  Toggles the bit at `index` in the bitmap and returns the new bitmap.

  i.e. it sets the bit to 1 if it was 0 or sets the bit to 0 if it was 1

  ## Examples
      iex> bm = Bitmap.new(10) |> Bitmap.set(4) |> Bitmap.set(8)
      iex> Bitmap.toggle(bm, 3)
      <<24, 2::size(2)>>
      iex> Bitmap.toggle(bm, 6)
      <<10, 2::size(2)>>
  """
  def toggle(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    {prefix, bit, rest} = split_at(bitmap, index)
    case {bit, prefix} do
      {1, <<>>} -> <<@unset_bit::size(1), rest::bitstring>>
      {0, <<>>} -> <<@set_bit::size(1), rest::bitstring>>
      {1, _}    -> <<prefix::size(index), @unset_bit::size(1), rest::bitstring>>
      {0, _}    -> <<prefix::size(index), @set_bit::size(1), rest::bitstring>>
    end
  end

  defp set_bit(bitmap, 0, bit) do
    {_prefix, _bit, rest} = split_at(bitmap, 0)
    <<bit::size(1), rest::bitstring>>
  end
  defp set_bit(bitmap, index, bit) do
    {prefix, _bit, rest} = split_at(bitmap, index)
    <<prefix::size(index), bit::size(1), rest::bitstring>>
  end

  defp split_at(bitmap, 0) do
    <<bit::size(1), rest::bitstring>> = bitmap
    {<<>>, bit, rest}
  end
  defp split_at(bitmap, index) do
    <<prefix::size(index), bit::size(1), rest::bitstring>> = bitmap
    {prefix, bit, rest}
  end

  defp fill_binary(binary, 0, _bit), do: binary
  defp fill_binary(binary, n, bit) do
    fill_binary(<<bit::size(1), binary::bitstring>>, n-1, bit)
  end
end
defmodule Bitmap.Binary do
  @moduledoc """
  Contains functions to create and work with a [bitmap](https://en.wikipedia.org/wiki/Bitmap)

  Bitmaps are also known as bit arrays, bit sets and is a fast space efficient 
  data structure for lookups

  The module has been designed to be pipe-friendly, so pipe 'em up
  """
  import Kernel, except: [to_string: 1]
  @behaviour Bitmap

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
      iex> Bitmap.Binary.new(400)
      <<0::size(400)>>
      iex> Bitmap.Binary.new([1,2,3,4,5])
      <<0::size(5)>>
      iex> Bitmap.Binary.new(1..25)
      <<0::size(25)>>
  """
  def new(argument)
  def new(size) when is_integer(size), do: <<0::size(size)>>
  def new(list) when is_list(list), do: new(length(list))
  def new(a..b), do: new(abs(b - a + 1))

  @doc """
  Returns the bit value at `index` in the bitmap

  ## Examples
      iex> bm = Bitmap.Binary.new(5)
      iex> Bitmap.Binary.at(bm, 2)
      0
      iex> bm = Bitmap.Binary.set(bm, 2)
      iex> Bitmap.Binary.at(bm, 2)
      1
  """
  def at(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    bitmap |> split_at(index) |> elem(1)
  end

  @doc """
  Returns a boolean representing whether the bit at position `index`
  is set or not

  ## Examples
      iex> bm = Bitmap.Binary.new(5) |> Bitmap.Binary.set(1) |> Bitmap.Binary.set(3)
      iex> Bitmap.Binary.set?(bm, 1)
      true
      iex> Bitmap.Binary.set?(bm, 4)
      false
  """
  def set?(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    at(bitmap, index) == @set_bit
  end

  @doc """
  Sets the bit at `index` in the bitmap and returns the new bitmap

  Index can also have a value `:all` in which case all bits
  will be set like in set_all

  ## Examples
      iex> Bitmap.Binary.set(Bitmap.Binary.new(5), 3)
      <<2::size(5)>>
      iex> Bitmap.Binary.set(Bitmap.Binary.new(1..10), 2)
      <<32, 0::size(2)>>
  """
  def set(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    set_bit(bitmap, index, @set_bit)
  end
  def set(bitmap, :all), do: set_all(bitmap)

  @doc """
  Set all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> Bitmap.Binary.set_all(Bitmap.Binary.new(10))
      <<255, 3::size(2)>>
      iex> Bitmap.Binary.set_all(Bitmap.Binary.new(100))
      <<255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 15::size(4)>>
  """
  def set_all(bitmap) do
    fill_binary(<<>>, bit_size(bitmap), @set_bit)
  end

  @doc """
  Returns a boolean representing whether the bit at position `index`
  is unset or not

  ## Examples
      iex> bm = Bitmap.Binary.new(5) |> Bitmap.Binary.set(1) |> Bitmap.Binary.set(3)
      iex> Bitmap.Binary.unset?(bm, 1)
      false
      iex> Bitmap.Binary.unset?(bm, 4)
      true
  """
  def unset?(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    at(bitmap, index) == @unset_bit
  end

  @doc """
  Unsets the bit at `index` in the bitmap and returns the new bitmap

  Index can also have a value `:all` in which case all bits
  will be unset like in unset_all

  ## Examples
      iex> bm = Bitmap.Binary.new(10) |> Bitmap.Binary.set(4) |> Bitmap.Binary.set(8)
      iex> Bitmap.Binary.unset(bm, 4)
      <<0, 2::size(2)>>
      iex> Bitmap.Binary.unset(bm, 8)
      <<8, 0::size(2)>>
  """
  def unset(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    set_bit(bitmap, index, @unset_bit)
  end
  def unset(bitmap, :all), do: unset_all(bitmap)

  @doc """
  Unsets all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> bm = Bitmap.Binary.new(10) |> Bitmap.Binary.set(4) |> Bitmap.Binary.set(8)
      iex> Bitmap.Binary.unset_all(bm)
      <<0, 0::size(2)>>
  """
  def unset_all(bitmap) do
    fill_binary(<<>>, bit_size(bitmap), @unset_bit)
  end

  @doc """
  Toggles the bit at `index` in the bitmap and returns the new bitmap
  i.e. it sets the bit to 1 if it was 0 or sets the bit to 0 if it was 1

  Index can also have a value `:all` in which case all bits will be toggled
  like in toggle_all

  ## Examples
      iex> bm = Bitmap.Binary.new(10) |> Bitmap.Binary.set(4) |> Bitmap.Binary.set(8)
      iex> Bitmap.Binary.toggle(bm, 3)
      <<24, 2::size(2)>>
      iex> Bitmap.Binary.toggle(bm, 6)
      <<10, 2::size(2)>>
  """
  def toggle(bitmap, index) when index >= 0 and index < bit_size(bitmap) do
    {prefix, bit, rest} = split_at(bitmap, index)
    case bit do
      1 -> <<prefix::size(index), @unset_bit::size(1), rest::bitstring>>
      0 -> <<prefix::size(index), @set_bit::size(1), rest::bitstring>>
    end
  end
  def toggle(bitmap, :all), do: toggle_all(bitmap)

  @doc """
  Toggles all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> bm = Bitmap.Binary.new(10) |> Bitmap.Binary.set(4) |> Bitmap.Binary.set(8)
      iex> Bitmap.Binary.toggle_all(bm)
      <<247, 1::size(2)>>
  """
  def toggle_all(bitmap) do
    toggle_binary(bitmap, bit_size(bitmap), <<>>)
  end

  @doc """
  Returns the string representation of the bitmap

  Note: This can be very long for huge bitmaps.
  """
  def to_string(bitmap) do
    to_string(bitmap, <<>>)
  end

  @doc """
  Inspects the bitmap and returns the string representation of the bitmap

  Note: This can be very long for huge bitmaps.
  """
  def inspect(bitmap) do
    bitmap |> to_string |> IO.inspect
  end

  defp to_string(<<>>, acc), do: String.reverse(acc)
  defp to_string(<<bit::size(1), rest::bitstring>>, acc) do
    case bit do
      1 -> to_string(rest, "#{@set_bit}" <> acc)
      0 -> to_string(rest, "#{@unset_bit}" <> acc)
    end
  end

  defp set_bit(bitmap, index, bit) do
    {prefix, o_bit, rest} = split_at(bitmap, index)
    cond do
      o_bit == bit -> bitmap
      true -> <<prefix::size(index), bit::size(1), rest::bitstring>>
    end
  end

  defp split_at(bitmap, index) do
    <<prefix::size(index), bit::size(1), rest::bitstring>> = bitmap
    {prefix, bit, rest}
  end

  defp fill_binary(binary, 0, _bit), do: binary
  defp fill_binary(binary, n, bit) do
    fill_binary(<<bit::size(1), binary::bitstring>>, n-1, bit)
  end

  defp toggle_binary(_bitmap, 0, acc), do: reverse_binary(acc)
  defp toggle_binary(<<bit::size(1), rest::bitstring>>, size, acc) do
    case bit do
      1 -> toggle_binary(rest, size-1, <<@unset_bit::size(1), acc::bitstring>>)
      0 -> toggle_binary(rest, size-1, <<@set_bit::size(1), acc::bitstring>>)
    end
  end

  defp reverse_binary(binary), do: reverse_binary(binary, bit_size(binary), <<>>)

  defp reverse_binary(_binary, 0, acc), do: acc
  defp reverse_binary(<<bit::size(1), rest::bitstring>>, size, acc) do
    reverse_binary(rest, size-1, <<bit::size(1), acc::bitstring>>)
  end
end
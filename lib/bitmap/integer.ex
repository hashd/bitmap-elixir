defmodule Bitmap.Integer do
  @moduledoc """
  Bitmap behaviour implementation using arbitrarily sized integers.
  """
  use Bitwise

  import Kernel, except: [to_string: 1]

  @behaviour Bitmap

  @typedoc """
  A typed map which holds the integer bitmap as defined by the module struct
  """
  @type t     :: %__MODULE__{}
  @type argt  :: non_neg_integer | [any] | Range.t
  @type index :: non_neg_integer
  @type bit   :: 1 | 0

  @set_bit    1
  @unset_bit  0

  defstruct size: 0, data: 0

  @doc """
  Creates and returns a bitmap of size corresponding to the `argument` passed.

  If `argument` is
  - integer, size of bitmap is equal to the `argument`
  - range, size of bitmap is equal to the length of `argument`
  - list, size of bitmap is equal to the length of `argument`

  > Note: All bits are set to 0 by default

  ## Examples
      iex> Bitmap.Integer.new(400)
      %Bitmap.Integer{data: 0, size: 400}
      iex> Bitmap.Integer.new([1,2,3,4,5])
      %Bitmap.Integer{data: 0, size: 5}
      iex> Bitmap.Integer.new(1..25)
      %Bitmap.Integer{data: 0, size: 25}
  """
  @spec new(argt) :: __MODULE__.t
  def new(argument)
  def new(size) when is_integer(size) and size >= 0, do: %__MODULE__{size: size}
  def new(list) when is_list(list), do: new(length(list))
  def new(a..b), do: new(abs(b - a) + 1)

  @doc """
  Returns the bit value at `index` in the bitmap

  ## Examples
      iex> bm = Bitmap.Integer.new(5)
      iex> Bitmap.Integer.at(bm, 2)
      0
      iex> bm = Bitmap.Integer.set(bm, 2)
      iex> Bitmap.Integer.at(bm, 2)
      1
  """
  @spec at(__MODULE__.t, index) :: bit
  def at(bitmap, index) do 
    (bitmap.data >>> index) &&& 1
  end

  @doc """
  Returns a boolean representing whether the bit at position `index`
  is set or not

  ## Examples
      iex> bm = Bitmap.Integer.new(5) |> Bitmap.Integer.set(1) |> Bitmap.Integer.set(3)
      iex> Bitmap.Integer.set?(bm, 1)
      true
      iex> Bitmap.Integer.set?(bm, 4)
      false
  """
  @spec set?(__MODULE__.t, index) :: boolean
  def set?(bitmap, index) do
    at(bitmap, index) == @set_bit
  end

  @doc """
  Sets the bit at `index` in the bitmap and returns the new bitmap

  Index can also have a value `:all` in which case all bits
  will be set like in set_all

  ## Examples
      iex> Bitmap.Integer.set(Bitmap.Integer.new(5), 3)
      %Bitmap.Integer{data: 8, size: 5}
      iex> Bitmap.Integer.set(Bitmap.Integer.new(1..10), 2)
      %Bitmap.Integer{data: 4, size: 10}
  """
  @spec set(__MODULE__.t, index) :: __MODULE__.t
  def set(%__MODULE__{size: size} = bitmap, index) when index >= 0 and index < size do
    %__MODULE__{bitmap | data: (bitmap.data ||| (@set_bit <<< index))}
  end
  def set(bitmap, :all), do: set_all(bitmap)

  @doc """
  Set all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> Bitmap.Integer.set_all(Bitmap.Integer.new(10))
      %Bitmap.Integer{data: 1023, size: 10}
      iex> Bitmap.Integer.set_all(Bitmap.Integer.new(100))
      %Bitmap.Integer{data: 1267650600228229401496703205375, size: 100}
  """
  @spec set_all(__MODULE__.t) :: __MODULE__.t
  def set_all(bitmap) do
    import Bitmap.Utils, only: [pow: 2]
    %__MODULE__{bitmap | data: pow(2, bitmap.size) - 1}
  end

  @doc """
  Returns a boolean representing whether the bit at position `index`
  is unset or not

  ## Examples
      iex> bm = Bitmap.Integer.new(5) |> Bitmap.Integer.set(1) |> Bitmap.Integer.set(3)
      iex> Bitmap.Integer.unset?(bm, 1)
      false
      iex> Bitmap.Integer.unset?(bm, 4)
      true
  """
  @spec unset?(__MODULE__.t, index) :: boolean
  def unset?(bitmap, index) do
    at(bitmap, index) == @unset_bit
  end

  @doc """
  Unsets the bit at `index` in the bitmap and returns the new bitmap

  Index can also have a value `:all` in which case all bits
  will be unset like in unset_all

  ## Examples
      iex> bm = Bitmap.Integer.new(10) |> Bitmap.Integer.set(4) |> Bitmap.Integer.set(8)
      iex> Bitmap.Integer.unset(bm, 4)
      %Bitmap.Integer{data: 256, size: 10}
      iex> Bitmap.Integer.unset(bm, 8)
      %Bitmap.Integer{data: 16, size: 10}
  """
  @spec unset(__MODULE__.t, index) :: __MODULE__.t
  def unset(%__MODULE__{size: size} = bitmap, index) when index >=0 and index < size do
    %__MODULE__{bitmap | data: (bitmap.data &&& ~~~(@set_bit <<< index))}
  end
  def unset(bitmap, :all), do: unset_all(bitmap)

  @doc """
  Unsets all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> bm = Bitmap.Integer.new(10) |> Bitmap.Integer.set(4) |> Bitmap.Integer.set(8)
      iex> Bitmap.Integer.unset_all(bm)
      %Bitmap.Integer{data: 0, size: 10}
  """
  @spec unset_all(__MODULE__.t) :: __MODULE__.t
  def unset_all(bitmap) do
    %__MODULE__{bitmap | data: 0}
  end

  @doc """
  Toggles the bit at `index` in the bitmap and returns the new bitmap
  i.e. it sets the bit to 1 if it was 0 or sets the bit to 0 if it was 1

  Index can also have a value `:all` in which case all bits will be toggled
  like in toggle_all

  ## Examples
      iex> bm = Bitmap.Integer.new(10) |> Bitmap.Integer.set(4) |> Bitmap.Integer.set(8)
      iex> Bitmap.Integer.toggle(bm, 3)
      %Bitmap.Integer{data: 280, size: 10}
      iex> Bitmap.Integer.toggle(bm, 6)
      %Bitmap.Integer{data: 336, size: 10}
  """
  @spec toggle(__MODULE__.t, index) :: __MODULE__.t
  def toggle(bitmap, index) do
    %__MODULE__{bitmap | data: (bitmap.data ^^^ (@set_bit <<< index))}
  end

  @doc """
  Toggles all bits in the bitmap and returns a new bitmap

  ## Examples
      iex> bm = Bitmap.Integer.new(10) |> Bitmap.Integer.set(4) |> Bitmap.Integer.set(8)
      iex> Bitmap.Integer.toggle_all(bm)
      %Bitmap.Integer{data: -273, size: 10}
  """
  @spec toggle_all(__MODULE__.t) :: __MODULE__.t
  def toggle_all(bitmap) do
    %__MODULE__{bitmap | data: ~~~bitmap.data}
  end

  @doc """
  Returns the string representation of the bitmap

  Note: This can be very long for huge bitmaps.
  """
  @spec to_string(__MODULE__.t) :: String.t
  def to_string(bitmap) do
    to_string(bitmap.data, bitmap.size, <<>>)
  end

  @doc """
  Inspects the bitmap and returns the string representation of the bitmap

  Note: This can be very long for huge bitmaps.
  """
  @spec inspect(__MODULE__.t) :: __MODULE__.t
  def inspect(bitmap) do
    bitmap |> to_string |> IO.inspect
  end

  defp to_string(_data, 0, acc), do: acc
  defp to_string(data, size, acc) do
    case data &&& 1 do
      1 -> to_string(data >>> 1, size - 1, "1" <> acc) 
      0 -> to_string(data >>> 1, size - 1, "0" <> acc)
    end
  end
end
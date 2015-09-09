defmodule Bitmap.Integer do
  @moduledoc """
  
  """
  import Kernel, except: [to_string: 1]
  use Bitwise

  # @behaviour Bitmap

  @type t :: %__MODULE__{}

  @set_bit    1
  @unset_bit  0

  defstruct size: 0, data: 0
  
  def new(argument)
  def new(size) when is_integer(size) and size >= 0, do: %__MODULE__{size: size}
  def new(list) when is_list(list), do: new(length(list))
  def new(a..b), do: new(:math.abs(b - a + 1))

  def at(bitmap, index) do 
    (bitmap.data >>> index) &&& 1
  end

  def set?(bitmap, index) do
    at(bitmap, index) == @set_bit
  end

  def set(bitmap, index) do
    %__MODULE__{bitmap | data: (bitmap.data ||| (@set_bit <<< index))}
  end

  def set_all(bitmap) do
    %__MODULE__{bitmap | data: (:math.pow(2, bitmap.size) |> trunc) - 1}
  end

  def unset?(bitmap, index) do
    at(bitmap, index) == @unset_bit
  end

  def unset(bitmap, index) do
    %__MODULE__{bitmap | data: (bitmap.data &&& ~~~(@set_bit <<< index))}
  end

  def unset_all(bitmap) do
    %__MODULE__{bitmap | data: 0}
  end

  def toggle(bitmap, index) do
    %__MODULE__{bitmap | data: (bitmap.data ^^^ (@set_bit <<< index))}
  end

  def toggle_all(bitmap) do
    %__MODULE__{bitmap | data: ~~~bitmap.data}
  end

  def to_string(bitmap) do
    to_string(bitmap.data, bitmap.size, <<>>)
  end

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
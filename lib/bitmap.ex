defmodule Bitmap do
  @moduledoc """
  Defines behaviour of a Bitmap, which can be implemented by the user. We
  provide implementations using Binary and Integers.

  This behavior has been designed to be pipe-friendly, so pipe 'em up.

  Methods are delegated to the default implementation which is
  currently, integer - Bitmap.Integer.
  """
  @type bitmap :: binary | Bitmap.Integer.t
  @type index  :: non_neg_integer
  @type bit    :: 1 | 0
  @type argt   :: non_neg_integer | list | Range.t

  @callback new(argt)             :: any
  @callback at(bitmap, index)     :: bit
  @callback set?(bitmap, index)   :: boolean
  @callback set(bitmap, index)    :: bitmap
  @callback set_all(bitmap)       :: bitmap
  @callback unset?(bitmap, index) :: boolean
  @callback unset(bitmap, index)  :: bitmap
  @callback unset_all(bitmap)     :: bitmap
  @callback toggle(bitmap, index) :: bitmap
  @callback toggle_all(bitmap)    :: bitmap
  @callback to_string(bitmap)     :: String.t
  @callback inspect(bitmap)       :: String.t

  defdelegate new(argument), to: Bitmap.Integer
  defdelegate at(bitmap, index), to: Bitmap.Integer
  defdelegate set?(bitmap, index), to: Bitmap.Integer
  defdelegate set(bitmap, index), to: Bitmap.Integer
  defdelegate set_all(bitmap), to: Bitmap.Integer
  defdelegate unset?(bitmap, index), to: Bitmap.Integer
  defdelegate unset(bitmap, index), to: Bitmap.Integer
  defdelegate unset_all(bitmap), to: Bitmap.Integer
  defdelegate toggle(bitmap, index), to: Bitmap.Integer
  defdelegate toggle_all(bitmap), to: Bitmap.Integer
  defdelegate to_string(bitmap), to: Bitmap.Integer
  defdelegate inspect(bitmap), to: Bitmap.Integer
end

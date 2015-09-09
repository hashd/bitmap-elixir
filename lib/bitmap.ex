defmodule Bitmap do
  @moduledoc """
  Defines behaviour of a Bitmap, which can be implemented by the user. We
  provide implementations using Binary and Integers.

  This behavior has been designed to be pipe-friendly, so pipe 'em up.

  Methods are delegated to the default implementation which is
  currently, integer - Bitmap.Integer.
  """
  use Behaviour

  @type bitmap :: binary | Bitmap.Integer.t
  @type index  :: non_neg_integer
  @type bit    :: 1 | 0
  @type argt   :: non_neg_integer | list | Range.t 

  defcallback new(argt)             :: any
  defcallback at(bitmap, index)     :: bit
  defcallback set?(bitmap, index)   :: boolean
  defcallback set(bitmap, index)    :: bitmap
  defcallback set_all(bitmap)       :: bitmap
  defcallback unset?(bitmap, index) :: boolean
  defcallback unset(bitmap, index)  :: bitmap
  defcallback unset_all(bitmap)     :: bitmap
  defcallback toggle(bitmap, index) :: bitmap
  defcallback toggle_all(bitmap)    :: bitmap
  defcallback to_string(bitmap)     :: String.t
  defcallback inspect(bitmap)       :: String.t

  defdelegate [new(argument), at(bitmap, index), set?(bitmap, index), 
    set(bitmap, index), set_all(bitmap), unset?(bitmap, index), 
    unset(bitmap, index), unset_all(bitmap), toggle(bitmap, index),
    toggle_all(bitmap), to_string(bitmap), inspect(bitmap)], to: Bitmap.Integer
end
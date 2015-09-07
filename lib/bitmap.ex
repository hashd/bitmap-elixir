defmodule Bitmap do
  @moduledoc """
  Contains functions to create and work with a [bitmap](https://en.wikipedia.org/wiki/Bitmap)
  Bitmaps are also known as bit arrays, bit sets and is a fast space efficient 
  data structure for lookups

  The module has been designed to be pipe-friendly, so pipe 'em up.

  Methods are delegated to the default implementation which is
  current binaries.
  """
  use Behaviour

  @type bitmap :: binary
  @type index  :: non_neg_integer
  @type bit    :: 1 | 0 

  defcallback new(non_neg_integer | list | Range.t) :: any
  defcallback at(bitmap, index)                     :: bit
  defcallback set?(bitmap, index)                   :: boolean
  defcallback set(bitmap, index)                    :: bitmap
  defcallback set_all(bitmap)                       :: bitmap
  defcallback unset?(bitmap, index)                 :: boolean
  defcallback unset(bitmap, index)                  :: bitmap
  defcallback unset_all(bitmap)                     :: bitmap
  defcallback toggle(bitmap, index)                 :: bitmap
  defcallback toggle_all(bitmap)                    :: bitmap

  defdelegate [new(argument), at(bitmap, index), set?(bitmap, index), 
    set(bitmap, index), set_all(bitmap), unset?(bitmap, index), 
    unset(bitmap, index), unset_all(bitmap), toggle(bitmap, index),
    toggle_all(bitmap)], to: Bitmap.Binary 
end
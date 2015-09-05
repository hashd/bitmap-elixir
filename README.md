Bitmap
======

In computing, a bitmap is a mapping from some domain (for example, a range of integers) to bits, that is, values which are zero or one. It is also called a bit array or bitmap index.

This is an Elixir implementation of a bit array using binaries.

It is a fast space efficient data structure for lookups.

### Examples
``` elixir
iex> bitmap = Bitmap.new(5)
<<0::size(5)>> # 00000
iex> Bitmap.set(bitmap, 2)
<<4::size(5)>> # 00100
iex> bitmap |> Bitmap.set(2) |> Bitmap.set(3)
<<6::size(5)>> # 00110
iex> bitmap |> Bitmap.set(2) |> Bitmap.set(3) |> Bitmap.unset(2)
<<2::size(5)>> # 00010
```

Read the documentation here for description and more examples.

##### License
This project is available under MIT License.

Bitmap
======

In computing, a bitmap is a mapping from some domain (for example, a range of integers) to bits, that is, values which are zero or one. It is also called a bit array or bitmap index.

This is an Elixir implementation of a bit array using binaries.

It is a fast space efficient data structure for lookups.

> Note: Index is zero based in the implementation

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

Read the latest documentation [here](http://hexdocs.pm/bitmap/overview.html) for elaborate description and more examples on how to use the library.

### TODO
[] Provide method to print the bitmap in its entire form
[] Provide alternate implementation using Integers since Erlang supports arbitrary sized integers
[] Benchmark implementations on a huge use case and compare numbers
[] Set the best implementation as default

##### License
This project is available under MIT License.

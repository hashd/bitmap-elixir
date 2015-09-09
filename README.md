Bitmap
======

In computing, a bitmap is a mapping from some domain (for example, a range of integers) to bits, that is, values which are zero or one. It is also called a bit array or bitmap index.

This is an Elixir implementation of a bit array. Two implementations are provided as part of the library, Binary and Integer. Integers are the default due to clear performance superiority based on benchmarks provided below.

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

### Benchmark using `Benchfella`
Results are based on sources present inside the `bench/` directory.

Bitmaps of size 1,000,000 are used to get benchmark on performance of the two
implementations provided in the library - Binary and Integer.
```
Benchmark Bitmap.Integer.at           100000000   0.05 µs/op
Benchmark Bitmap.Integer.unset_all    100000000   0.06 µs/op
Benchmark Bitmap.Integer.set?         100000000   0.07 µs/op
Benchmark Bitmap.Integer.new           10000000   0.11 µs/op
Benchmark Bitmap.Integer.set             500000   7.50 µs/op
Benchmark Bitmap.Integer.toggle          500000   7.52 µs/op
Benchmark Bitmap.Integer.toggle_all      100000   21.33 µs/op
Benchmark Bitmap.Integer.unset           100000   22.83 µs/op
Benchmark Bitmap.Binary.unset_all         50000   74.54 µs/op
Benchmark Bitmap.Binary.new               20000   79.34 µs/op
Benchmark Bitmap.Binary.set?              20000   90.18 µs/op
Benchmark Bitmap.Binary.at                20000   99.70 µs/op
Benchmark Bitmap.Binary.toggle            10000   169.97 µs/op
Benchmark Bitmap.Binary.unset             10000   207.38 µs/op
Benchmark Bitmap.Binary.set               10000   208.58 µs/op
Benchmark Bitmap.Integer.set_all             10   111083.80 µs/op
Benchmark Bitmap.Binary.set_all              10   143833.10 µs/op
Benchmark Bitmap.Binary.to_string             1   80530194.00 µs/op
Benchmark Bitmap.Integer.to_string            1   89035291.00 µs/op
Benchmark Bitmap.Binary.toggle_all            1   451542225.00 µs/op
```

##### License
This project is available under MIT License.

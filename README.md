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
- [ ] Provide method to print the bitmap in its entire form
- [ ] Provide alternate implementation using Integers since Erlang supports arbitrary sized integers
- [ ] Benchmark implementations on a huge use case and compare numbers
- [ ] Set the best implementation as default

### Benchmark results using `Benchfella`

```
Benchmark Bitmap.Integer.unset_all    100000000   0.06 µs/op
Benchmark Bitmap.Integer.new          100000000   0.10 µs/op
Benchmark Bitmap.Integer.toggle_all    10000000   0.23 µs/op
Benchmark Bitmap.Binary.new            10000000   0.32 µs/op
Benchmark Bitmap.Integer.set_all       10000000   0.43 µs/op
Benchmark Bitmap.Integer.at               50000   44.48 µs/op
Benchmark Bitmap.Integer.set?             10000   152.66 µs/op
Benchmark Bitmap.Integer.set              10000   254.05 µs/op
Benchmark Bitmap.Binary.unset_all          5000   314.17 µs/op
Benchmark Bitmap.Binary.set_all           10000   316.71 µs/op
Benchmark Bitmap.Integer.unset             5000   360.51 µs/op
Benchmark Bitmap.Binary.at                 5000   377.12 µs/op
Benchmark Bitmap.Binary.set?               5000   477.58 µs/op
Benchmark Bitmap.Integer.toggle            5000   487.54 µs/op
Benchmark Bitmap.Integer.to_string         5000   739.98 µs/op
Benchmark Bitmap.Binary.unset              2000   835.74 µs/op
Benchmark Bitmap.Binary.set                2000   916.66 µs/op
Benchmark Bitmap.Binary.toggle_all         1000   1564.62 µs/op
Benchmark Bitmap.Binary.toggle             1000   1706.22 µs/op
Benchmark Bitmap.Binary.to_string           500   5608.34 µs/op
```

##### License
This project is available under MIT License.

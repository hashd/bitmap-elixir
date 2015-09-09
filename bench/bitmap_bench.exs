defmodule BitmapBench do
  use Benchfella

  @size 1000000
  @list Enum.to_list(0..(@size-1))
  @bb   Bitmap.Binary.new(@size)
  @bi   Bitmap.Integer.new(@size)
  @sbb  Bitmap.Binary.new(@size) |> Bitmap.Binary.set_all
  @sbi  Bitmap.Integer.new(@size) |> Bitmap.Integer.set_all

  bench "Benchmark Bitmap.Binary.new" do
    Bitmap.Binary.new(@size)
  end

  bench "Benchmark Bitmap.Integer.new" do
    Bitmap.Integer.new(@size)
  end

  bench "Benchmark Bitmap.Binary.set" do
    Bitmap.Binary.set(@bb, div(@size, 2))
  end

  bench "Benchmark Bitmap.Integer.set" do
    Bitmap.Integer.set(@bi, div(@size, 2))
  end

  bench "Benchmark Bitmap.Binary.toggle" do
    Bitmap.Binary.toggle(@bb, div(@size, 2))
  end

  bench "Benchmark Bitmap.Integer.toggle" do
    Bitmap.Integer.toggle(@bi, div(@size, 2))
  end

  bench "Benchmark Bitmap.Binary.unset" do
    Bitmap.Binary.unset(@sbb, div(@size, 2))
  end

  bench "Benchmark Bitmap.Integer.unset" do
    Bitmap.Integer.unset(@bi, div(@size, 2))
  end

  bench "Benchmark Bitmap.Binary.set_all" do
    @bb |> Bitmap.Binary.set_all
  end

  bench "Benchmark Bitmap.Integer.set_all" do
    @bi |> Bitmap.Integer.set_all
  end

  bench "Benchmark Bitmap.Binary.unset_all" do
    @sbb |> Bitmap.Binary.unset_all
  end

  bench "Benchmark Bitmap.Integer.unset_all" do
    @sbi |> Bitmap.Integer.unset_all
  end

  bench "Benchmark Bitmap.Binary.toggle_all" do
    @sbb |> Bitmap.Binary.toggle_all
    @bb |> Bitmap.Binary.toggle_all
  end

  bench "Benchmark Bitmap.Integer.toggle_all" do
    @sbi |> Bitmap.Integer.toggle_all
    @bi |> Bitmap.Integer.toggle_all
  end

  bench "Benchmark Bitmap.Binary.at" do
    Bitmap.Binary.at(@bb, div(@size, 2))
  end

  bench "Benchmark Bitmap.Integer.at" do
    Bitmap.Integer.at(@bi, div(@size, 2))
  end

  bench "Benchmark Bitmap.Binary.set?" do
    Bitmap.Binary.set?(@bb, div(@size, 2))
  end

  bench "Benchmark Bitmap.Integer.set?" do
    Bitmap.Integer.set?(@bi, div(@size, 2))
  end

  bench "Benchmark Bitmap.Binary.to_string" do
    @sbb |> Bitmap.Binary.to_string
    @bb |> Bitmap.Binary.to_string
  end

  bench "Benchmark Bitmap.Integer.to_string" do
    @sbi |> Bitmap.Integer.to_string
    @bi |> Bitmap.Integer.to_string
  end
end
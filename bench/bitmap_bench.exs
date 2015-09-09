defmodule BitmapBench do
  use Benchfella

  @size 1000
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
    @list |> Enum.reduce(@bb, fn ele, acc -> Bitmap.Binary.set(acc, ele) end)
  end

  bench "Benchmark Bitmap.Integer.set" do
    @list |> Enum.reduce(@bi, fn ele, acc -> Bitmap.Integer.set(acc, ele) end)
  end

  bench "Benchmark Bitmap.Binary.toggle" do
    @list |> Enum.reduce(@bb, fn ele, acc -> Bitmap.Binary.toggle(acc, ele) end)
    @list |> Enum.reduce(@sbb, fn ele, acc -> Bitmap.Binary.toggle(acc, ele) end)
  end

  bench "Benchmark Bitmap.Integer.toggle" do
    @list |> Enum.reduce(@bi, fn ele, acc -> Bitmap.Integer.toggle(acc, ele) end)
    @list |> Enum.reduce(@sbi, fn ele, acc -> Bitmap.Integer.toggle(acc, ele) end)
  end

  bench "Benchmark Bitmap.Binary.unset" do
    @list |> Enum.reduce(@sbb, fn ele, acc -> Bitmap.Binary.unset(acc, ele) end)
  end

  bench "Benchmark Bitmap.Integer.unset" do
    @list |> Enum.reduce(@sbi, fn ele, acc -> Bitmap.Integer.unset(acc, ele) end)
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
    @list |> Enum.each(fn idx -> Bitmap.Binary.at(@bb, idx) end)
  end

  bench "Benchmark Bitmap.Integer.at" do
    @list |> Enum.each(fn idx -> Bitmap.Integer.at(@bi, idx) end)
  end

  bench "Benchmark Bitmap.Binary.set?" do
    @list |> Enum.each(fn idx -> Bitmap.Binary.set?(@sbb, idx) end)
  end

  bench "Benchmark Bitmap.Integer.set?" do
    @list |> Enum.each(fn idx -> Bitmap.Integer.set?(@sbi, idx) end)
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
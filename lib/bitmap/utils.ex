defmodule Bitmap.Utils do

  @doc """
  Binary exponentiation to support large integers which :math.pow can't since
  it returns floats

  ## Examples
      iex> Bitmap.Utils.pow(2, 10)
      1024
      iex> Bitmap.Utils.pow(2, 9)
      512
  """
  def pow(x, n) when is_integer(x) and is_integer(n) and n >= 0, do: pow(x, n, 1)

  defp pow(_x, 0, acc), do: acc
  defp pow(x, 1, acc), do: x * acc
  defp pow(x, n, acc) when rem(n, 2) == 0, do: pow(x * x, div(n, 2), acc)
  defp pow(x, n, acc) when rem(n, 2) == 1, do: pow(x * x, div(n - 1, 2), acc * x)
end
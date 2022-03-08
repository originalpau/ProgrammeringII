defmodule Brot do

  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)
    i = 0
    test(i, z0, c, m)
  end

  # 0 is returned when the complex number is a set of mandelbrot
  # 1 when it defineftly is not. The higher i number, the closer it is to mandelbrot.
  def test(m, _z, _c, m) do 0 end
  def test(i, z, c, m) do
    case Cmplx.abs(z) do
      a when a > 2 -> i
      _ ->
        z1 = Cmplx.add(Cmplx.sqr(z), c)
        test(i+1, z1, c, m)
    end
  end

end

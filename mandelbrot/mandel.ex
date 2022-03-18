defmodule Mandel do

  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) -> Cmplx.new(x + k * (w-1), y-k * (h-1)) end
    rows(width, height, trans, depth)
  end

  def rows(width, height, trans, depth) do
    pixel = fn(x, y) ->
      c = trans.(x, y)
      d = Brot.mandelbrot(c, depth)
      Color.convert(d, depth)
    end
    for y <- 1..height, do: for(x <- 1..width, do: pixel.(x,y))
  end

  ################################################################
  def demo() do
    small(-2.6, 1.2, 1.2)
  end

  def small(x0, y0, xn) do
  width = 960
  height = 540
  depth = 64
  k = (xn - x0) / width
  image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
  PPM.write("small.ppm", image)
  end


end

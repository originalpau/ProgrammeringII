defmodule Cmplx do

  # Returns new complex number with real number r and imaginary i
  def new(r, i) do {r, i} end

  # Adds two complex numbers
  def add(a, b) do
    {r, i} = a
    {x, y} = b
    {r+x, i+y}
  end

  # Squares a complex number
  def sqr(a) do
    {x, y} = a
    {x*x - y*y, 2*x*y}
  end

  # The absolute value of a
  def abs(a) do
    {x, y} = a
    :math.sqrt(x*x + y*y)
  end
end

defmodule Test do

  def toCelsius(f) do
    (f - 32)/1.8
  end

  def double(n) do
    n * 2
  end

  def area(a, b) do
    a * b
  end

  def square(a) do
    area(a, a)
  end
  
  def circle(x) do
    x * x * :math.pi 
  end

end

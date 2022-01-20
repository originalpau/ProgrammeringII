defmodule Rec do
  
  def product(m, n) when m >= 0 do
    case m do
      0 -> 0
      _ -> n + product(m-1, n)
    end
  end

  def exp(x, n) when n >=0 do
    case n do
      0 -> 0
      1 -> x
      _ -> product(exp(x, n-1), x)
    end
  end

  def exp_fast(x, 1) do x end
  def exp_fast(x, n) when n > 0 do
    case rem(n, 2) do
      0 -> exp_fast(x, div(n,2)) * n 
      1 -> exp_fast(x, n-1) * x
    end
  end


end

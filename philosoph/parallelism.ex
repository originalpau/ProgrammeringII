defmodule Parallel do

  def sequential(n) do
    {t, f} = :timer.tc(fn() -> fib_seq(n) end)
    IO.puts("sequential fib(#{n}) = #{f} in #{trunc(t/1000)} ms")
    :ok
  end

  def combined(n,m) do
    {t, f} = :timer.tc(fn() -> comb(n,m) end)
    IO.puts("Combined fib(#{n}) = #{f} in #{trunc(t/1000)} ms")
    :ok
  end

  def fib_seq(0) do 1 end
  def fib_seq(1) do 1 end
  def fib_seq(n) do fib_seq(n-1) + fib_seq(n-2) end

  def comb(0,_) do 0 end
  def comb(1,_) do 1 end
  def comb(n,m) when n > m do
    r1 = paral(fn() -> comb(n-1, m) end)
    r2 = paral(fn() -> comb(n-2, m) end)
    f1 = collect(r1)
    f2 = collect(r2)
    f1 + f2
  end
  def comb(n,_) do fib_seq(n) end

  def paral(f) do
    ref = make_ref()
    me = self()
    spawn(fn() -> send(me, {:comb, ref, f.()}) end)
    ref
  end

  def collect(ref) do
    receive do
      {:comb, ^ref, res} -> res
    end
  end

  # def stream() do
  #   writer = PPM.writer("reduced.ppm", self())
  #   reducer = Stream.start(gray_reduce(), writer)
  #   grayer = Stream.start(rgb_to_gray(), reducer)
  #   PPM.reader("hockey.ppm", grayer)
  #   receive do
  #     :done
  #   end
  # end

end

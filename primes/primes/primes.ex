defmodule Primes do

  def z(n) do
    fn() ->
      :io.format("generate ~w\n", [n])
      {n, z(n+1)}
    end
  end

  def filter(n, f) do
    {c,n} = n.()
    :io.format("check if ~w is divisable by ~w\n", [c, f])
    if rem(c, f) == 0 do
      :io.format("discard ~w\n", [c])
      filter(n, f)
    else
      :io.format("accept ~w\n", [c])
      {c, fn() -> filter(n, f) end}
    end
  end

  def sieve(n, p) do
    {next, n} = filter(n,p)
    {next, fn() -> filter(n, next) end}
  end

  def primesf() do
    fn() -> {2, fn() -> sieve(z(2), 2) end} end
  end

  ########### Struct ########################

  defstruct [:next]

  def primes() do
    %Primes{next: fn() -> {2, fn() -> sieve(z(2), 2) end} end}
  end

  ########### Protocol ########################

  defimpl Enumerable do
    def count(_) do {:error, __MODULE__} end
    def member?(_,_) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end

    def reduce(_, {:halt, acc}, _fun) do
      {:halted, acc}
    end

    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end
    
    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p,acc), fun)
    end
  end

  def next(%Primes{next: n}) do
    {p, n} = n.()
    {p, %Primes{next: n}}
  end

end

# Enum.take(Stream.map(Primes.primes(),fn(x) -> 2*x end), 5)
# =
# Primes.primes() |> Stream.map(&(&1*2)) |> Enum.take(5)

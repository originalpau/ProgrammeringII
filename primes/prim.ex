defmodule Prim do
  # Returns a list with elements evaluated to true when appliying
  # function f on it.
  def filter([], _) do [] end
  def filter([h|t], f) do
    case f.(h) do
      true -> [h|filter(t, f)]
      false -> filter(t, f)
    end
  end

  # Adds prime to the head of primes list. Reverse in the end.
  def third(n) do third(Enum.to_list(2..n), []) end
  def third([], primes) do rev(primes) end
  def third([h|t], primes) do
    third(filter(t, &(rem(&1, h) != 0)), [h|primes])
  end

  # Append an element to end of list -> Gives result [2,3,5,7,100]
  # If you want to append list to another list, edit [y] to simply y to get cleaner output.
  # O(N) of the first argument list. This function is the same as the inbuilt list ++ list.
  def append([], y) do [y] end
  def append([h|t], y) do
    [h|append(t,y)]
  end

  # Reverse the list.
  def rev(l) do rev(l, []) end
  def rev([], res) do res end
  def rev([h|t], res) do
    rev(t, [h|res])
  end

  # Adds prime to end of primes list.
  def second(n) do second(Enum.to_list(2..n), []) end
  def second([], primes) do primes end
  def second([h|t], primes) do
    second(filter(t, &(rem(&1, h) != 0)), append(primes, h))
  end

  # Deletes numbers that are not prime without using an extra list.
  def first(n) do del(Enum.to_list(2..n)) end

  def del([]) do [] end
  def del([h|t]) do
    [h|del(filter(t, &(rem(&1, h) != 0)))]
  end

  ###################################################################

  def bench() do
    {:ok, file} = File.open("prim.dat", [:write, :list])
    # antal loop
    l = 100
    # list storlek: Enum.to_list(2..n)
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024,16*1024]
    :io.format(file, "# Benchmark for calculating primes with different lists, ~w times, in mikrosecs.~n", [l])
    :io.format(file, "# size\t\tfirst\t\tsecond\t\tthird\n", [])
    Enum.each(ls, fn n -> bench(l, n, file) end)
    File.close(file)
  end

  # l = antalet loop
  # n = längden på listan
  def bench(l, n, file) do
    # Skapar random tal upp till i storlek
    # seq = Enum.map(1..n, fn(_) -> :rand.uniform(100000) end)
    f = time(l, fn() -> first(n) end)
    s = time(l, fn() -> second(n) end)
    t = time(l, fn() -> third(n) end)
    #:io.format(file, "~w\t\t~.2f\t\t~.2f\t\t~.2f\n", [n, f/l, s/l, t/l])
    :io.format(file, "~w\t\t~.2f\t\t~.2f\t\t~.2f\n", [n, f/l, s/l, t/l])

  end

  def time(l, function) do
    elem(:timer.tc(fn () -> loop(l, function) end),0)
  end

  def loop(0,_) do :ok end
  def loop(l,bench) do
    bench.()
    loop(l-1, bench)
  end

end

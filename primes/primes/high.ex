defmodule High do
  def foo(x) do
    y=3
    fn(v) -> v + y + x end
  end

  # Fold right
  # foldr( [1,2,3,4], 0, %(%1+2) )
  # (1 + (2 + (3 + (4 + 0))))
  def foldr([], acc, _op) do acc end
  def foldr([h|t], acc, op) do
    op.(h, foldr(t, acc, op))
  end

  # High.foldr([1,2,3,4,5], 0, fn(x, acc) -> x + acc end)
  # High.foldr([1,3,9,4], 0, fn(x, acc) -> if x > acc do x else acc end end)

  # Returns the number of elements in the list.
  def gurka(l) do
    f = fn(_, a) -> a + 1 end
    foldr(l, 0, f)
  end

  # Returns the list in reverse order.
  def tomat(l) do
    f = fn(h,a) -> a ++ [h] end
    foldr(l, [], f)
  end

  # Fold left: Tail recursive foldr
  # foldl( [1,2,3,4], 0, %(%1+2) )
  # (4 + (3 + (2 + (1 + 0))))
  def foldl([], acc, _op) do acc end
  def foldl([h|t], acc, op) do
    foldl(t, op.(h, acc), op)
  end

  # Returns the list in reverse order.
  # This function is more effective than tomat/1, because it uses
  # foldl which is tail recursive.
  def morot(lst) do
    op = fn(h, acc) -> [h|acc] end
    foldl(lst, [], op)
  end

  # With append, foldr is more effective than foldl, because we will do nothing when we go down,
  # but when going back we will do append on every little list e.
  def append_right(l) do
    f = fn(e,a) -> e ++ a end
    foldr(l, [], f)
  end

  # The accumulator grows very fast, so it will be a very expensive operation in the end.
  def append_left(l) do
    f = fn(e,a) -> a ++ e end
    foldl(l, [], f)
  end

  # This is the most effective way for append when the order dosen't matter.
  def append_best(lst) do
    op = fn(e, acc) -> e ++ acc end
    foldl(lst, [], op)
  end

  # foldr and foldl is in-built in the List module.

  ######## Enum ################

  def map([], _op) do [] end
  def map([h|t], op) do
    [op.(h) | map(t, op)]
  end

  def filter([], _) do [] end
  def filter([h|t], op) do
    if op.(h) do
      [h| filter(t, op)]
    else
      filter(t, op)
    end
  end

  ######## Infinity #############

  def infinity() do
    fn () -> infinity(0) end
  end

  def infinity(n) do
    [n | fn() -> infinity(n+1) end]
  end

  def fib() do
    fn() -> fib(1,1) end
  end

  def fib(f1, f2) do
    [f1 | fn() -> fib(f2, f1+f2) end]
  end

  def sumr({:range, from, from}) do from end
  def sumr({:range, from, to}) do
    from + sumr({:range, from+1, to})
  end

  # Denna implementering gör det mer flexibelt, lätt att ändra om till ex. produkten av elementen.
  def sum(range) do
    reduce(range, {:cont, 0}, fn(x, acc) -> {:cont, x + acc} end)
  end

  def prod(range) do
    reduce(range, {:cont, 1}, fn(x, acc) -> {:cont, x * acc} end)
  end

  def reduce({:range, from, to}, {:cont, acc}, fun) do
    if from <= to do
      reduce({:range, from+1, to}, fun.(from, acc), fun)
    else
      {:done, acc}
    end
  end

  # closure: returnerar en funktion med kunskap om vad range och fun är.
  def reduce(range, {:suspend, acc}, fun) do
    {:suspended, acc, fn(cmd) -> reduce(range, cmd, fun) end}
  end

  def reduce(_, {:halt, acc}, _) do
    {:halted, acc}
  end

  def take(range, n) do
    reduce(range, {:cont, {:sofar, 0, []}},
    fn (first_elem, {:sofar, num_seen, seen_elem}) ->
      num_seen = num_seen + 1
      if num_seen >= n do
        {:halt, Enum.reverse([first_elem | seen_elem])}
      else
        {:cont, {:sofar, num_seen, [first_elem | seen_elem]}}
      end
    end)
  end

  def head(range) do
    reduce(range, {:cont, :na}, fn (x, _) -> {:suspend, x} end)
  end


end

defmodule Fib do

  def bench() do
    {:ok, file} = File.open("test.dat", [:write, :list])
    # antal loop
    l = 100
    # list storlek
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format(file, "# Benchmark for sorting, ~w times, in a list or tuple, all times in ms.~n", [l])
    # :io.format(file, "#~8s ~8s ~8s~n", ["l", "list", "tree"])
    :io.format(file, "# size\t\tlist\t\ttree\n", [])
    Enum.each(ls, fn n -> bench(l, n, file) end)
    File.close(file)
  end

  # l = antalet loop
  # n = längden på listan
  def bench(l, n, file) do
    # Skapar random tal upp till i storlek
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(100000) end)
    li = time(l, fn() -> list(seq) end)
    t = time(l, fn() -> tree(seq) end)
    :io.format(file, "~w\t\t~.2f\t\t~.2f\n", [n, li/l, t/l])
  end

  def tree(seq) do
    List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
  end
  def list(seq) do
    List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
  end

  def time(l, function) do
    elem(:timer.tc(fn () -> loop(l, function) end),0)
  end

  def loop(0,_) do :ok end
  def loop(l,bench) do
    bench.()
    loop(l-1, bench)
  end

  ########### Sorting functions ############
  def list_new() do [] end

  def list_insert(e,[]) do [e] end
  def list_insert(e,[h|t]) do
    if e < h do
      [e,h|t]
    else
      [h|list_insert(e,t)]
    end
  end

  def tree_new() do :nil end

  def tree_insert(e, :nil) do {:node, e, :nil, :nil} end
  def tree_insert(e, {:node, v, left, right}) do
    if e < v do
      {:node, v, tree_insert(e, left), right}
    else
      {:node, v, left, tree_insert(e, right)}
    end
  end

  def dummy_new() do :ok end
  def dummy_insert(_,_) do :ok end

end

defmodule Bench do

  def bench() do bench(100) end
  def bench(l) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    # i = längden på listan,
    # f = den funktion som vi skall bencha
    time = fn (i, f) ->
      # Skapar random tal upp till i storlek
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      # Accessar element 0 på tupeln som skapas av :timer (alltså runtime)
      # för sortering mha en funktion, med en specifik listlängd.
      elem(:timer.tc(fn () -> loop(l, fn -> f.(seq) end) end),0)
    end

    # i är längden på listan
    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end

      # sparar runtime tiden för en listlängd på variabeln.
      # Hämtad från funktionen time.
      tl = time.(i, list)
      tt = time.(i, tree)

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end

  def loop(0,_) do :ok end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end

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

  end

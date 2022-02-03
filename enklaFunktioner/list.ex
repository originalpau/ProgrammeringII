defmodule ListOps do

  def nth(1, [h|_t]) do h end
  def nth(n, [_h|t]) do
    nth(n-1, t)
  end

  def len([]) do 0 end
  def len([_h|t]) do
    len(t) + 1
  end

  def sum([]) do 0 end
  def sum([h|t]) do
    h + sum(t)
  end

  def duplicate([h|[]]) do [h,h] end
  def duplicate([h|t]) do
    [h, h | duplicate(t)]
  end

  def add(x,[]) do [x] end
  def add(x, [h|t]) do
    #case x do
      #^h -> [x|t]
      #_ -> [h | add(x, t)]
    #end

    # if x == h do
    #   IO.puts("Already in list!")
    #   #[x|t]
    # else
    #   [h| add(x,t)]
    # end

    #THE RIGHT ONE
    cond do
      x == h -> [x|t]
      true -> [h| add(x,t)]
    end
  end

  #insertion sort
  def isort(l) do isort(l, []) end

  def isort([], sorted) do sorted end
  def isort([h|t], sorted) do
    isort(t, insert(h,sorted))
  end

  def insert(e,[]) do [e] end
  def insert(e,[h|t]) do
    if e < h do
      [e,h|t]
    else
      [h|insert(e,t)]
    end
  end


end

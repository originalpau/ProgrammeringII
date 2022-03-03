defmodule Sort do
    #insertion sort, using list
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

    #binary tree, sorting
    def bsort(l) do bsort(l, :nil) end

    def bsort([], sorted) do sorted end
    def bsort([h|t], sorted) do
      bsort(t, bst_insert(h,sorted))
    end

    def bst_insert(e, :nil) do {:node, e, :nil, :nil} end #root and leaf
    def bst_insert(e, {:node, v, left, right}) do
      if e < v do
        {:node, v, bst_insert(e, left), right}
      else
        {:node, v, left, bst_insert(e, right)}
      end
    end

end

# For testing in command line
# seq = Enum.map(1..12, fn(_) -> :rand.uniform(100000) end)
# List.foldr(seq, [], fn (e, acc) -> Bench.list_insert(e, acc) end)

# Quicksort, from Complexity lecture
# def qsort([]) do [] end
# def qsort([h] do [h] end
# def qsort(all) do
#   {low, high} = partition(all)
#   lowS = qsort(low)
#   highS = qsort(high)
#   append(lowS, highS)
# end

# # Mergesort
# def msort([]) do [] end
# def msort(l) do
#   {a, b} =  split(l)
#   as = msort(a)
#   bs = msort(b)
#   merge(as, bs)
# end

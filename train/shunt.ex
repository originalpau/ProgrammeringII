defmodule Shunt do
  import Modify
  import Moves

  def split(state, elem) do
    pos = position(state, elem)
    {take(state, pos-1), drop(state, pos)}
  end

  def find([],[]) do [] end
  def find(xs, ys) do find(xs, ys, []) end

  def find([], [], moves) do moves end
  def find(xs, [y|ys], moves) do
    {hs, ts} = split(xs, y)
    found_moves = [{:one, length(ts)+1}, {:two, length(hs)}, {:one, (length(ts)+1)*-1}, {:two, (length(hs)*-1)}]
    [_,_,_,_,{[x|new_xs],[],[]}] = move(found_moves, {xs,[],[]})
    find(new_xs, ys, append(moves,found_moves))
  end

end

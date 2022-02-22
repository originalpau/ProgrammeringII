defmodule Moves do
  import Shunt

  def single(move, {main, one, two}) do
    case move do
      {:one, n} ->
        if n > 0 do
          {remove_end(main, n), add_first(main, one, n), two}
        else
          {add_end(main, one, n), remove_first(one, n), two}
        end
      {:two, n} ->
        if n > 0 do
          {remove_end(main, n), one, add_first(main, two, n)}
        else
          {add_end(main, one, n), one, remove_first(two, n)}
        end
      {_, 0} -> {main, one, two}
    end
  end

  # n is greater than zero
  def remove_end(main, n) do take(main, length(main)-n) end
  def add_first(main, side, n) do append(drop(main, length(main)-n), side) end

  # n is less than zero
  def add_end(main, side, n) do append(main, take(side, n*-1)) end
  def remove_first(side, n) do drop(side, n*-1) end

  def move(moves, init) do move(moves, init, [init]) end
  def move([], _, states) do reverse(states) end
  def move([h|t], current, states) do
    state = single(h, current)
    move(t, state, [state|states])
  end

end


# Moves.move([{:one,1},{:two,1},{:one,-1}], {[:a,:b],[],[]})

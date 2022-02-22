defmodule Shunt do

  # take/2 returns the list containing the first n elements of the list
  def take(l, n) do take(l, n, []) end
  def take(_, 0, l) do reverse(l) end
  #append nu eller reverse i slutet, väljer att göra det i slutet så man endast behöver göra det en gång.
  def take([h|rest], n, result) do take(rest, n-1, [h|result]) end

  def reverse(l) do reverse(l, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

  # drop/2 returns the list without its first n elements
  def drop(l, 0) do l end
  def drop([_h|t], n) do drop(t, n-1) end

  # append/2 returns the list with the elements of the other list appended
  def append(x, y) do
    rev = reverse(x)
    tailr(rev,y)
  end
  def tailr([], y) do y end
  def tailr([h|t], y) do tailr(t, [h|y]) end

  # member/2 tests wheter elem is an element of list
  def member([], elem) do {:false, elem} end
  def member([elem|_t], elem) do {:true, elem} end
  def member([_h|t], elem) do member(t, elem) end

  # position/2 returns the first position of elem in the list. Index starts at 1.
  def position(l, elem) do position(l, elem, 1) end
  def position([h|t], elem, count) do
    if h == elem do
      count
    else
      position(t, elem, count+1)
    end
  end
end

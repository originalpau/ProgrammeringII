defmodule Register do

  def new() do
    {0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0,
     0, 0, 0, 0}
  end

  def read(_, 0) do 0 end
  def read(reg, index) do elem(reg, index) end

  def write(reg, 0, _) do reg end
  def write(reg, index, value) do put_elem(reg, index, value) end

end

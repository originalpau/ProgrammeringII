defmodule Waiter do

  def start do
    stick = spawn_link(fn -> waiter(0, 4) end)
    stick
  end

  def waiter(eating, seats) do
    receive do
      {:sit, name, ref} when eating < seats ->
        IO.puts("#{name} to be served, (#{eating+1} out of #{seats})")
        send(ref, :serve)
        waiter(eating+1, seats)

      {:leave, name, phil} ->
        IO.puts("#{name} leaving, (#{eating-1} out of #{seats})")
        send(phil, :left)
        waiter(eating-1, seats)
    end
  end

end

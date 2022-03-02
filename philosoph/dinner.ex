defmodule Dinner do
  def start(), do: spawn(fn -> init() end)

  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    waiter = Waiter.start()
    Philosopher.start(5, c1, c2, "Arendt", ctrl, waiter)
    Philosopher.start(5, c2, c3, "Hypatia", ctrl, waiter)
    Philosopher.start(5, c3, c4, "Simone", ctrl, waiter)
    Philosopher.start(5, c4, c5, "Elisabeth", ctrl, waiter)
    Philosopher.start(5, c5, c1, "Ayn", ctrl, waiter)
    wait(5, [c1,c2,c3,c4,c5])
  end

  def wait(0,chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    IO.puts("Finished")
  end
  def wait(n, chopsticks) do
    receive do
      :done -> wait(n-1, chopsticks)
      :abort ->
        :io.format("dinner aborted~")
        Process.exit(self(), :kill)
    end
  end

end

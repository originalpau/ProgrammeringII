defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> available() end)
    stick
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def request(stick) do
    send(stick, {:request, self()})
    receive do
      :granted -> {:ok, :granted}
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    send(stick, :quit)
  end

end

# Testa i kompilatorn, när den är död,
# eller när vi bara har en process aktiv så körs programmet i en evighetsloop

# stick = Chopstick.start()
# Chopstick.request(stick)
# Chopstick.return(stick)
# Chopstick.quit(stick)

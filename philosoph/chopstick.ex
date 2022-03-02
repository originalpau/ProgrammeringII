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

        # with make_ref
        {:request, ref, from} ->
          send(from, {:granted, ref})
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

  # def request(stick) do
  #   send(stick, {:request, self()})
  #   receive do
  #     :granted -> {:ok, :granted}
  #   end
  # end

  # asynchronus request
  def request(stick) do
    ref = make_ref()
    send(stick, {:request, ref, self()})
    ref
  end

  def granted(ref) do
    receive do
      {:granted, ^ref} -> {:ok, ref}
    end
  end

  def granted(ref, timeout) do
    receive do
      {:granted, ^ref} -> {:ok, ref}
    after
      timeout -> :no
    end
  end

  # Break the potential deadlock with request
  # that specifies milliseconds to wait for a chopstick.
  def request(stick, timeout) do
    send(stick, {:request, self()})
    receive do
      :granted -> {:ok, :granted}
    after
      timeout -> :no
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

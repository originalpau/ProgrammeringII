defmodule Philosopher do
  @dream 1000
  @eat 50
  @delay 200

  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn() -> dreaming(hunger, right, left, name, ctrl) end)
  end

  def dreaming(0, _, _, name, ctrl) do
    IO.puts("#{name} is done eating")
    send(ctrl, :done)
  end

  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming...")
    sleep(@dream)
    IO.puts("#{name} wakes up!")
    waiting(hunger, right, left, name, ctrl)
  end

  defp waiting(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is waiting for chopsticks, #{hunger} left")
    case Chopstick.request(left) do
      {:ok, :granted} ->
        IO.puts("#{name} received a chopstick!")
        sleep(@delay)
        case Chopstick.request(right) do
          {:ok, :granted} ->
            IO.puts("#{name} received both chopstick!")
            eat(hunger, right, left, name, ctrl)
        end
    end
  end

  def eat(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is eating, #{hunger} left")
    sleep(@eat)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger-1, right, left, name, ctrl)
  end

end

# left = Chopstick.start
# right = Chopstick.start
# name = "Rudolf"
# pid = spawn(fn() -> Philosopher.start(5, left, right, name, self()) end)

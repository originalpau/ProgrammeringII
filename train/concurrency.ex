defmodule Foo do

  #pid = spawn(fn() -> 42 end)
  # Process id blir olika varje gång vid iex
  #pid = spawn(module_Foo, fn_name_start, arg_[42])
  # (Om ovanstående syntax används måste funktionsnamnet start vara exporterat från modulen, synligt utifrån)
  # föredras att skrivas som
  #pid = spawn(fn() -> Foo.start([42]) end)
  # Står funktionen i samma modul kan man bara skriva
  #pid = spawn(fn -> start([42]) end)

  #send(pid, msg)
  #send(pid, {:hello, 345}) # out: {:hello, 345}
  # pid processen lever inte längre, då den blev klar när 42 var exekverat.
  # Men inget felmeddelande levereras tillbaks.

  def start() do
    receive do
      {:hello, msg} ->
        IO.puts("Wow! #{msg}")
        start()
      :quit -> :ok
    end
  end

  # KOMPILATOR iex:
  # pid = spawn(fn() -> Foo.start() end)
  # send(pid, {:hello, "whatever message"})
  # send(pid, :quit)    # Processen lever inte längre efter detta

  ############## Example ##############
  # Processens tillstånd är en summa
  def server(sum) do
    receive do
      {:add, x} -> server(sum + x)
      {:sub, x} -> server(sum - x)
    end
  end

  # self() returnerar alltid samma pid.
  # myPid = self()
  # send(self(), :hello)
  # receive do msg -> msg end
  # Om man gör receive när meddelandekön är tom, kommer kompilatorn jobba förevigt och fastna.

  ################# SELECTIVE RECEIVE ##################
  def closed(s) do
    receive do
      {:add, x} -> closed(s + x)
      :open -> open(s)
      :done -> {:ok, s}
    end
  end

  def open(s) do
    receive do
      {:mul, x} -> open(s * x)
      {:sub, x} -> open (s - x)
      :close -> closed(s)
    end
  end

  # Vi sparkar igång med:
  # spawn(fn() -> closed(4) end)
  # Meddelande sekvensen ser ut så här:
  # {:sub, 4}, :open, {:mul, 4}, {:add, 2}, :close, {:add, 2}, :done

  ############# BESKRIVA EN PROCESS ############
  # FSM
  # Sekvensdiagram
  # Flow-based programming (FBP)
  # Domain Specific Language

  # Sätten att beskriva en process kompletterar varandra och kan användas tillsammans.
  # Ingen är tänkt att göra allt, både översiktligt och detaljerat.

  # Elixir: Implicit deferral -> FSM where messages are allowed to arrive too early

  ############## EXAMPLE 2 ####################
  def acc(saldo) do
    receive do
      {:deposit, money} -> acc(saldo + money)
      {:withdraw, money} -> acc(saldo - money)
      {:request, from} ->
        send(from, {:saldo, saldo})
        acc(saldo)
    end
  end

  def check(acc) do
    send(acc, {:request, self()})
    receive do
      {:saldo, saldo} -> saldo
    end
  end

  def doit() do
    acc = spawn(fn() -> acc(0) end)
    send(acc, {:deposit, 20})
    send(acc, {:withdraw, 10})
    acc
  end

end

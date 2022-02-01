defmodule Emulator do

  #@type label(), data() :: [{:label, :arg}, {:word, 12}]
  #@type expr() :: {:prgm, code(), data()}

  def test() do
    code = [{:addi, 1, 0, 5}, # $1 <- 5
      {:lw, 2, 0, :arg}, # $2 <- data[:arg]
      {:add, 4, 2, 1}, # $4 <- $2 + $1
      {:addi, 5, 0, 1}, # $5 <- 1
      {:label, :loop},
      {:sub, 4, 4, 5}, # $4 <- $4 - $5
      {:out, 4}, # out $4
      {:bne, 4, 0, :loop}, # branch if not equal
      :halt]
    data = [{:label, :arg}, {:word, 12}]
    run({:prgm, code, data})
  end

  def test2() do
    code = [{:add, 1, 0, 4},
            {:out, 1},
            {:label, :loop},
            :halt]
    data = [{:label, :arg}, {:word, 12}]
    prgm = {:prgm, code, data}
    run(prgm)
  end

  def run(prgm) do
    {code, data} = Program.load(prgm)
    out = Out.new()
    reg = Registers.new()
    run(0, code, reg, data, out)
  end

  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)
    case next do
      :halt -> Out.close(out)

      {:out, rs} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        out = Out.put(out, s)
        run(pc, code, reg, mem, out)

      {:addi, rd, rs, imm} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        reg = Register.write(reg, rd, s + imm)
        run(pc, code, reg, mem, out)

    end
  end
end

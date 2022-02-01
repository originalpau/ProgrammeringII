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
    reg = Register.new()
    run(0, code, reg, data, out)
  end

  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)
    :io.format("instruction ~w\nRegisters: ~w\n\n", [next, reg])
    case next do
      :halt -> Out.close(out)

      {:out, rs} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        :io.format("out:  ~w\n", [s])
        out = Out.put(out, s)
        :io.format("outList:  ~w\n", [out])
        run(pc, code, reg, mem, out)

      {:addi, rd, rs, imm} ->
        reg_val = Register.read(reg, rs)
        reg = Register.write(reg, rd, reg_val + imm)
        run(pc+4, code, reg, mem, out)

      {:add, rd, rs, rt} ->
        rs_val = Register.read(reg, rs)
        rt_val = Register.read(reg, rt)
        reg = Register.write(reg, rd, rs_val + rt_val)
        run(pc+4, code, reg, mem, out)

      {:sub, rd, rs, rt} ->
        rs_val = Register.read(reg, rs)
        rt_val = Register.read(reg, rt)
        reg = Register.write(reg, rd, rs_val - rt_val)
        run(pc+4, code, reg, mem, out)

      {:bne, rs, rt, imm} ->
        rs_val = Register.read(reg, rs)
        rt_val = Register.read(reg, rt)
        cond do
          rs_val != rt_val -> run(pc+imm, code, reg, mem, out)
          true -> run(pc+4, code, reg, mem, out)
        end

      {:lw, rd, rt, imm} ->
        rt_val = Register.read(reg, rt)
        mem_addr = rt_val + imm
        word_val = Program.read_mem(mem, mem_addr)
        :io.format("lw_val: ~w\n", [word_val])
        reg = Register.write(reg, rd, word_val)
        :io.format("reg: ~w\n", [reg])
        run(pc+4, code, reg, mem, out)

    end
  end
end

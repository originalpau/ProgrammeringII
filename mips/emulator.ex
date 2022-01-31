defmodule Emulator do

  #@type label(), data() :: [{:label, :arg}, {:word, 12}]
  #@type expr() :: {:prgm, code(), data()}

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

    end
  end
end

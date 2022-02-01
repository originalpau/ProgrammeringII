defmodule Test do

  # def test() do
  #   code = Program.load(demo())
  #   mem = Memory.new([])
  #   out = Out.new()
  #   Emulator.run(code, mem, out)
  # end

  def demo() do
    code = [
     {:addi, 1, 0, 10},    # $1 <- 10
     {:addi, 2, 0, 5},     # $2 <- 5
     {:add, 3, 1, 2},      # $3 <- $1 + $2
     {:sw, 3, 0, 7},       # mem[0 + 7] <- $3
     {:lw, 4, 0, 7},       # $4 <- mem[0+7]
     {:addi, 5, 0, 1},     # $5 <- 1
     {:sub, 4, 4, 5},      # $4 <- $4 - $5
     {:out, 4},            # out $4
     {:bne, 4, 0, -3},     # branch if not equal
     {:halt}]
     data = [{:word, 12}]
     prgm = {:prgm, code, data}
    {prgm_code, prgm_data} = Program.load(prgm)
    :io.format("code : ~w\ndata: ~w\n\n", [prgm_code, prgm_data])
    out = Out.new()
    Emulator.run(prgm_code, prgm_data, out)
  end

  def demo2() do
    code = [{:addi, 1, 0, 4},
            {:out, 1},
            {:addi, 5, 0, 1},
            {:label, :loop},
            {:sub, 1, 1, 5},
            {:bne, 1, 0, :loop},
            :halt]
    data = [{:label, :arg}, {:word, 12}]
    prgm = {:prgm, code, data}
    {prgm_code, prgm_data} = Program.load(prgm)
    :io.format("code : ~w\ndata: ~w\n\n", [prgm_code, prgm_data])
    out = Out.new()
    Emulator.run(prgm_code, prgm_data, out)
  end

  def demo3() do
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
  prgm = {:prgm, code, data}
  {prgm_code, prgm_data} = Program.load(prgm)
  :io.format("code : ~w\ndata: ~w\n\n", [prgm_code, prgm_data])
  out = Out.new()
  Emulator.run(prgm_code, prgm_data, out)
  end
end

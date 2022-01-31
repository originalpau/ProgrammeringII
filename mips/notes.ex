def module Test do

  [{:add, 2, 4},
    {:sub, 2, 4},
    {:sw, 2, 12},
    {:add, 3, 4},
    {:add, 3, 4},
    {:beq, 2, 3, -12},
    {:add, 4, 5}
  ] 
  
  # [{adress, värde}] e.x. [{20, 45},{12, 123}]
  # Kan använda binary trees..map
  def store(adr, val, []) do [{adr, val}] end
  def store(adr, val, [{adr,_}|tail]) do [{adr, val}|tail] end
  def store(adr, val, [h|tail]) do [h| store(adr, val, tail)] end

  def load (adr, []) do 0 end 
  def load (adr, [{adr, val}|_]) do val end 
  def load (adr, [_|tail]) do load(adr, tail) end 

  def store(pc, code) do
    pc = div(pc, 4)
    instr_get(pc, code)
  end

  def instr_get(0, [instr|_]) do instr end
  def instr_get(n, [_|rest]) do instr_get(n-1, rest) end

end

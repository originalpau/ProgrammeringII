defmodule Program do

  def test() do
    code = [{:add, 1, 0, 4},
            {:out, 1},
            {:label, :loop},
            {:sub, 4, 4, 5},
            {:sub, 4, 4, 5},
            {:sub, 4, 4, 5},
            {:bne, 1, 0, :loop},
            :halt]
    data = [{:label, :arg}, {:word, 12}]
    prgm = {:prgm, code, data}
    {code, data} = load(prgm)
    :io.format("code : ~w\ndata: ~w\n\n", [code, data])
  end

  # [index, värde]  {24, 12}
  # [{index, label}] {24, :arg}
  # varje värde tar upp 1 word = 4 bytes var

  # data = [{:label, :arg}, {:word, 12}]
  def load({:prgm, code, data}) do
    {labels, memory} = load_data(data)
    :io.format("labels : ~w\nmemory: ~w\n\n", [labels, memory])

    prgm = load_code(code, labels)
    :io.format("program : ~w\n\labels: ~w\n\n", [prgm, labels])
    {List.to_tuple(prgm), memory}
  end

  # [index, label], [index, värde]
  def load_data(data) do store(data, 0, [], []) end

  def store([], _, labels, values) do {labels, values} end
  def store([h|t], index, labels, values) do
    case h do
      {:label, l} -> store(t, index, [{index, l}|labels], values)
      {:word, w} -> store(t, index+4, labels, [{index, w}|values])
    end
  end

  # [{index, label}], [] kod utan labels
  def load_code(code, labels) do
    {i, labels, instr} = get_labels(code, 0, labels, [])
    :io.format("i: ~w\nlabels : ~w\ninstr: ~w\n\n", [i, labels, instr])

    load_code(instr, i, labels, [])
  end

  def get_labels([], i, labels, instr) do {i, labels, instr} end
  def get_labels([h|t], index, labels, instr) do
    case h do
      {:label, l} -> get_labels(t, index, [{index, l}|labels], instr)
      _ -> get_labels(t, index+4, labels, [h|instr])
    end
  end

  def load_code([], _, _, prgm) do prgm end
  def load_code([instr|t], i, labels, prgm) do
    load_code(t, i-4, labels, [load_code(instr, i, labels)|prgm])
  end

  def load_code(instr, i, labels) do
    case instr do
      {:bne, rs, rt, l} -> {:bne, rs, rt, find_bne_addr(l, i, labels)}
      {:lw, rd, rt, l} -> {:lw, rd, rt, find_mem_key(l, labels)}
      _ -> instr
    end
  end

  def find_bne_addr(l, i, labels) do
    {addr, label} = lookup(l, labels, [])
    (addr-i)
  end

  def find_mem_key(l, labels) do
    {addr, label} = lookup(l, labels, [])
    addr
  end

  def lookup(_, [], _) do :error end
  def lookup(label, [{addr,label}|t], searched) do {addr, label} end
  def lookup(label, [h|t], searched) do
    lookup(label, t, [h|searched])
  end


  def read_instruction(code, pc) do
    pc = div(pc, 4)
    elem(code, pc)
  end

  def read_mem(data, addr) do
    {addr, val} = lookup(addr, data, [])
    val
  end


end

defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    #'this is something that we should encode'
    #'this is an example of a huffman tree'
    #'huffman'
    #'foo'
  end

  # def test do
  #   sample = sample()
  #   tree = tree(sample)
  #   encode = encode_table(tree)
  #   decode = decode_table(tree)
  #   text = text()
  #   seq = encode(text, encode)
  #   decode(seq, decode)
  # end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    seq = encode(sample, encode)
    decode(seq, encode)
  end

  # Count frequency using insertion sort,
  # freq table is represented with [{char, freq}, ..]
  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char|rest], freq) do
    freq(rest, update(char, freq))
  end

  # Note: tänkte uppdaterata tabellen och hålla den sorterad samtidigt, men blev för svårt att
  # följa och maintain. Samma anledning med att skapa en sekvens med träd.
  def update(char, []) do [{char, 1}] end
  def update(char, [{char, n}|t]) do [{char, n+1}|t] end
  def update(char, [h|t]) do [h| update(char, t)] end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def huffman(l) do
    sorted = isort(l)
    build(sorted)
  end

  # Sort table with insertion sort list
  def isort(l) do isort(l, []) end

  def isort([], sorted) do sorted end
  def isort([h|t], sorted) do
    isort(t, insert(h,sorted))
  end

  def insert(e,[]) do [e] end
  def insert({e, x},[{h, y}|t]) do
    if x < y do
      [{e, x}, {h, y}|t]
    else
      [{h, y} |insert({e, x},t)]
    end
  end

  # binary sort
  # def bsort(l) do bsort(l, :nil) end

  # def bsort([], sorted) do sorted end
  # def bsort([h|t], sorted) do
  #   bsort(t, bst_insert(h,sorted))
  # end

  # def bst_insert(e, :nil) do {:node, e, :nil, :nil} end #root and leaf
  # def bst_insert({e,x}, {:node, {v,y}, left, right}) do
  #   if x < y do
  #     {:node, {v,y}, bst_insert({e,x}, left), right}
  #   else
  #     {:node, {v,y}, left, bst_insert({e,x}, right)}
  #   end
  # end

  # # Combine lowest frequencies to new node and insert to table ordered
  def build([{tree, _}]) do tree end
  def build([{c1, f1}, {c2, f2} | rest]) do
    build(insert({{c1,c2}, f1+f2}, rest))
  end

  def encode_table(tree) do
    collect(tree)
  end

  # Output from {{110, 102},{{104, 117}, {109, 97}}}:
  # [['n', 102], ['h', 117], 'm', 97]
  # def collect(tree) do collect(tree, []) end
  # def collect({left, right}, char) do
  #   [collect(left, char) | collect(right, char)]
  # end
  # def collect(c, char) do [c | char] end

  # Collect characters from tree
  # def collect(tree) do collect(tree, [], []) end
  # def collect({left, right}, char, rest) do
  #   collect(left, char, [right|rest])
  # end
  # def collect(c, char, []) do [c|char] end
  # def collect(c, char, [h|rest]) do
  #   collect(h, [c|char], rest)
  # end

  # Path
  def collect(tree) do collect(tree, [], []) end
  def collect({left, right}, path, acc) do
    left = collect(left, [0|path], acc)
    collect(right, [1|path], left)
  end
  def collect(c, path, acc) do
    [{c, Enum.reverse(path)} | acc]
  end

  # Characters
  # def collect(tree) do collect(tree, []) end
  # def collect({left, right}, acc) do
  #   left = collect(left, acc)
  #   collect(right, left)
  # end
  # def collect(c, acc) do
  #   [c | acc]
  # end

  # def decode_table(tree) do
  #   # To implement...
  # end

  def encode(text, table) do encode(text, table, table, []) end
  def encode([], _, _, seq) do seq end
  def encode([char|t], [{char, path}|_], table, seq) do
    encode(t, table, table, seq ++ path)
  end
  def encode(text, [_|rest], table, seq) do
    encode(text, rest, table, seq)
  end

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end

  ############# Benchmark ###############

  # Get a suitable chunk of text to encode.
  def read(file, n) do
  {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)
    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end

  #This is the benchmark of the single operations in the
  #Huffman encoding and decoding process.
  # iex> Huffman.bench("kallocain.txt", num_of_char)
  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    IO.puts("text of #{c} characters")
    {tree, t2} = time(fn -> tree(text) end)
    IO.puts("tree built in #{t2} ms")
    {table, t3} = time(fn -> encode_table(tree) end)
    s = length(table)
    IO.puts("table of size #{s} in #{t3} ms")
    {encoded, t5} = time(fn -> encode(text, table) end)
    IO.puts("encoded in #{t5} ms")
    {_, t6} = time(fn -> decode(encoded, table) end)
    IO.puts("decoded in #{t6} ms")

    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end
end

defmodule Example do

  #sample must contain all chars that will later be encoded
  def sample() do
      'the quick brown fox jumps over the lazy dog
      this is a sample text that we will use when we build
      up a table we will only handle lower case letters and
      no punctuation symbols the frequency will of course not
      represent english but it is probably not that far off'
  end

  def text() do
      'this is something'
  end

  def test() do
      sample = sample()
      tree = build_tree(sample)
      encode = encode_table(tree)
  end

  def test_huffman() do
      sample = text()
      tree = build_tree(sample)
      encode = encode_table(tree)
      #decode = decode_table(tree)
      text = text()
      seq = encode(text, encode)
      #IO.inspect(decode(seq, decode))
  end

  #count the letter frequencies and build the huffman tree
  def build_tree(sample) do
      freq = freq(sample)
      huffman(freq)
  end

  #iterate the sample and count the frequencies
  def freq(sample) do
      freq(sample, [])
  end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do freq(rest, update(char, freq)) end

  #update the frequency for the given char
  def update(char, []) do [{char, 1}] end
  def update(char, [{char, n} | freq]) do [{char, n+1} | freq] end
  def update(char, [head | freq]) do [head | update(char, freq)] end

  #sort the frequencies and build the tree
  def huffman(freq) do
      sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
      huffman_tree(sorted)
  end

  #insert the tuple at right position
  def insert({char, freq}, []) do [{char, freq}] end
  def insert({a, afreq}, [{b, bfreq} | rest]) when afreq < bfreq do
      [{a, afreq}, {b, bfreq} | rest]
  end
  def insert({a, afreq}, [{b, bfreq} | rest]) do
      [{b, bfreq} | insert({a, afreq}, rest)]
  end

  #Build the tree
  def huffman_tree([{tree, _}]) do tree end
  def huffman_tree([{a, afreq}, {b, bfreq} | rest]) do
      huffman_tree(insert({{a, b}, afreq + bfreq}, rest))
  end

  #Create the encoding table
  #The encoding table is sorted by the shortest path...why not?
  def encode_table(tree) do
      encoded = codes(tree, [], [])
      unsorted_encoded = add_path_length(encoded, [])
      Enum.sort(unsorted_encoded, fn({_, _, x}, {_, _, y}) -> x < y end)
  end

  def add_path_length([], acc) do acc end
  def add_path_length([{char, path} = t | rest], acc) do
      add_path_length(rest, [{char, path, path_length(t)} | acc])
  end

  def path_length({_, []}) do 0 end
  def path_length({_, [_head | tail]}) do
      1 + path_length({:foo, tail})
  end

  #Save path for each leaf
  def codes({a, b}, path, acc) do
      left = codes(a, [0 | path], acc)
      codes(b, [1 | path], left)
  end
  def codes(a, code, acc) do
      [{a, Enum.reverse(code)} | acc]
  end

  #Use the tree for decoding
  def decode_table(tree) do tree end

  #Encode with the given encoding table
  def encode([], _) do [] end
  def encode([char | rest], table) do
      {_, code, _} = List.keyfind(table, char, 0)
      code ++ encode(rest, table)
  end

  #Decode with the tree
  def decode(seq, tree) do decode(seq, tree, tree) end
  def decode([], char, _) do [char] end
  def decode([0 | seq], {left, _}, tree) do decode(seq, left, tree) end
  def decode([1 | seq], {_, right}, tree) do decode(seq, right, tree) end
  def decode(seq, char, tree) do [char | decode(seq, tree, tree)] end

  #Read and decode a text file
  def kallocain(n, coding) do
    {:ok, file} = File.open("kallocain.txt", [:read])
    binary = IO.read(file, n)
    File.close(file)

    length = byte_size(binary)
    character_decode(binary, length, coding)
  end

  #Character encodings that are available:
  # - latin1 will force to read one byte at a time
  # - utf8 will read the content character by character
  #   where a character might be two bytes (or more). The
  #   characters: å, ä and ö are two bytes.
  # - utf16 will read the content two bytes at a time
  #   (possibly more).
  # - utf24 is a faked coding scheme that will simply read
  #   three bytes at a time.
  def character_decode(binary, length, :latin1) do
    {:binary.bin_to_list(binary), length}
  end
  def character_decode(binary, length, :utf8) do
      {:unicode.characters_to_list(binary, :utf8), length}
  end
  def character_decode(binary, length, :utf16) do
      case :unicode.characters_to_list(binary, :utf16) do
          {:incomplete, list, rest} ->
          {list, length - byte_size(rest)}

          list ->
              {list, length}
      end
  end

  #This is the benchmark of the single operations in the
  #Huffman encoding and decoding process.
  def bench(n, coding) do
    {sample, _} = kallocain(n, coding)
    {{text, b}, t1} = time(fn -> kallocain(n, coding) end)
    c = length(text)
    {tree, t2} = time(fn -> build_tree(sample) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("read in #{t1} ms")
    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  #Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

end

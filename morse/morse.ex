defmodule Morse do

  def name() do '.--. .- ..- .-.. .. -. .- ..-- .... ..- .- -. --. ' end

  def test() do
   table = encode_table()
   encode('paulina huang', table, [])
  end

  def test2() do
    signal = name()
    decode(signal, morse(), [])
  end

  def test3() do
    path(morse(), [])
  end

#---------------Encode table -----------------------#
  def encode_table() do
    list = path(morse(), [])
    #|> sort()
    Enum.sort(list, fn({e, _}, {x, _}) -> e < x end)  #Uses merge sort
    |> fill(0)
    |> List.to_tuple
  end

  def path(:nil, _) do [] end
  def path({:node, :na, long, short}, code) do
    path(long, [?-|code]) ++ path(short, [?.|code])
  end
  def path({:node, char, long, short}, code) do
    [{char, code}] ++ path(long, [?-|code]) ++ path(short, [?.|code])
    #[{char, Enum.reverse(code)}] ++ l ++ s
  end
#----------------------------------------------------#
  def sort(l) do sort(l, []) end
  def sort([], sorted) do sorted end
  def sort([h|t], sorted) do sort(t, insert(h, sorted)) end

  def insert(e,[]) do [e] end
  def insert({e, x},[{h, y}|t]) do
    if e < h do
      [{e, x}, {h, y}|t]
    else
      [{h, y} |insert({e, x},t)]
    end
  end
  #----------------------------------------------------#
  defp fill([], _), do: []
  defp fill([{n, code} | codes], n), do: [code | fill(codes, n + 1)]
  defp fill(codes, n), do: [:na | fill(codes, n + 1)]
  #---------------------Encode-------------------------------#

  # append list istället för [elem, ' ' | morse] för att få bort fnuttar, annars blir det
  # som flera element, komplexiteten på append beror på den första listan.
  def encode([], _, morse) do Enum.reverse([32 | morse])
  end
  def encode([c|rest], table, []) do
    encode(rest, table, elem(table, c))
  end
  def encode([c|rest], table, morse) do
    encode(rest, table, elem(table, c) ++ [32] ++ morse)
  end

  #----------------- Decode --------------------------------#
  #def decode(signal, morse(), decoded)
  def decode([], _, text) do Enum.reverse(text) end
  def decode([?- | signal], {:node, _, left, _}, text) do decode(signal, left, text) end
  def decode([?. | signal], {:node, _, _, right}, text) do decode(signal, right, text) end
  def decode([?\s | signal], {:node, :na, _, _}, text) do  decode(signal, morse(), [?* | text]) end
  def decode([?\s | signal], {:node, char, _, _}, text) do decode(signal, morse(), [char | text]) end

  # def collect(tree) do collect(tree, []) end
  # def collect({:node, value, left, right}, acc) do
  #   left = collect(left, [{value}|acc])
  #   collect(right, left)
  # end
  # def collect(nil, acc) do acc end


  def morse() do
  {:node, :na,
    {:node, 116,
      {:node, 109,
        {:node, 111,
          {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
          {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
        {:node, 103,
          {:node, 113, nil, nil},
          {:node, 122,
            {:node, :na, {:node, 44, nil, nil}, nil},
            {:node, 55, nil, nil}}}},
      {:node, 110,
        {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
        {:node, 100,
          {:node, 120, nil, nil},
          {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
    {:node, 101,
      {:node, 97,
        {:node, 119,
          {:node, 106,
            {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
            nil},
          {:node, 112,
            {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
            nil}},
        {:node, 114,
          {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
          {:node, 108, nil, nil}}},
      {:node, 105,
        {:node, 117,
          {:node, 32,
            {:node, 50, nil, nil},
            {:node, :na, nil, {:node, 63, nil, nil}}},
          {:node, 102, nil, nil}},
        {:node, 115,
          {:node, 118, {:node, 51, nil, nil}, nil},
          {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def base(), do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '

  def rolled(), do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '


end

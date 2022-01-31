defmodule Queue do
  #Elementen som ligger i den vänstra listan har legat där längst.
  #Elementen som ligger i den högra listan har nyss lagts till, i slutet pa kön.
  def new() do {:queu, [], []} end

  #Lägga till element är nu konstant.
  def add({:queu, front, back}, elem) do {:queu, front, [elem|back]} end

  #Konstant.
  def remove({:queu, [], []}) do :error end
  #Linjär p.g.a. reverse(back) som är proportionell till antal element i kön.
  #Varje element kommer vara skydlig för en rekursion när dem ska bli framflyttade.
  #Sa det elementet kommer ha en konstant faktor.
  def remove({:queu, [], back}) do remove({:queu, reverse(back), []}) end
  #Konstant.
  def remove({:queu, [elem|rest], back}) do {:ok, elem, {:queu, rest, back}} end

  def reverse(lst) do reverse(lst, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

  #Komplexiteten för att addera element till kön är direkt proportionelig till vart
  #elementet ligger i kön. Ligger den sist i kön är det O(n).
  #def add([], elem) do [elem] end
  #def add([h|t], elem) do
    #[h| add(t, elem)]
  #end

  #Komplexiteten för att ta bort element frn kön är konstant.
  #def remove([]) do :error end
  #def remove([elem|rest]) do {:ok, elem, rest} end

end

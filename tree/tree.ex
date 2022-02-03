defmodule Tree do
  #@type root_node() :: {:leaf, elem}
  #@type branch_node :: {:node, elem, left, right}
  #@type empty_tree :: :nil
  # tree = {:node, :b, {:leaf, :a}, {:leaf, :c}}

  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end
  def member(elem, {:node, elem, _, _}) do :yes end
  #Sökning i ett ordnat träd. Ordningen sker baserat pa nycklarna.
  def member(elem, {:node, e, left, right}) do
    if elem < e do
      member(elem, left)
    else
      member(elem, right)
    end
  end

  # Sökning i ett oordnat träd.
  #def member(elem, {:node, _, left, right}) do
    #case member(elem, left) do
      #:yes -> :yes
      #:no -> case member(elem, right) do
        #:yes -> :yes
        #:no -> :no
      #end
    #end
  #end

  #Sökning i ett ordnat träd, utan löv.
  def lookup(_, :nil) do :no end
  def lookup(key, {:node, key, value, _, _}) do {:value, value} end
  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

  #Modifiera värdet som är associerat med nyckeln i trädet.
  def modify(_, _, :nil) do :nil end
  def modify(key, value, {:node, key, _, left, right}) do
    {:node, key, value, left, right}
  end
  def modify(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, modify(key, value, left), right}
    else
      {:node, k, v, left, modify(key, value, right)}
    end
  end

  #Lägga till ett key-value pair i trädet.
  def insert(key, value, :nil) do {:node, key, value, :nil, :nil} end
  def insert(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, insert(key, value, left), right}
    else
      {:node, k, v, left, insert(key, value, right)}
    end
  end

  #Ta bort ett värde i ett träd.
  def delete(key, {:node, key, _, :nil, :nil}) do :nil end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, :nil}) do left end
  # def delete(key, {:node, key, _, left, right}) do
  #   {k, v} = ...
  #   {:node, ..., ..., ..., ...}
  #   #{:node, left, right}
  # end
  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end
end

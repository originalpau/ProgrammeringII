defmodule Deriv do

  #Definiering av datastrukturerna är för egen dokumentation.
  #Det blir inga kompileringsfel vid felanvändning av dessa aritmetiska uttryck.
  #Även konstanter som pi är definierad som en variabel i detta program. 
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  |   {:add, expr(), expr()}
  |   {:mul, expr(), expr()}
  |   {:exp, expr(), literal()} 
  |   {:log, expr()}
  |   {:div, expr(), expr()}

  #Test
  def test_add() do
    e = {:add,
      {:mul, {:num, 2}, {:var, :x}},
      {:num, 4}}
    d =  deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test_exp() do
    e = {:add,
      {:exp, {:var, :x}, {:num, 3}},
      {:num, 4}}
    d =  deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end
  
  def test_negExp() do
    e = {:exp, {:var, :x}, {:num, -3}}
    d = deriv(e, :x)
    c = calc(d, :x, 3)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test_sub() do
    e = {:sub,
      {:exp, {:var, :x}, {:num, 2}},
      {:mul, {:num, 5}, {:var, :x}}}
    d =  deriv(e, :x)
    #c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    #IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test_div() do
    e = {:div, {:num, 5}, {:var, :x}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  def test_log() do
    e = {:log, {:mul, {:var, :x}, {:num, 2}}} 
    #e = {:log, {:var, :x}} 
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  def test_all() do
    e = {:mul,
      {:exp, {:var, :x}, {:num, 2}},
      {:add, {:var, :y}, {:num, 2}}} 
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
  end

  #Derivative rules
  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add, 
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e, v)}
  end

  def deriv({:sub, e1, e2}, v) do
    {:sub, deriv(e1, v), deriv(e2, v)}
  end
  
  # 1/x 
  def deriv({:div, {:num, n}, {:var, v}}, v) do {:div, {:num, n*-1}, {:exp, {:var, v}, {:num, 2}}} end

  def deriv({:div, e1, e2}, v) do
    {:div,
      {:add,
        {:mul, e2, deriv(e1, v)},
        {:mul, {:num, -1}, {:mul, e1, deriv(e2, v)}}},
      {:exp, e2, {:num, 2}}}
  end

  # ln(x) with one variable
  def deriv({:log, {:var, v}}, v) do {:div, {:num, 1}, {:var, v}} end  

  # ln(2x) with multiplication
  def deriv({:log, {:mul, _, {:var, v}}}, v) do {:div, {:num, 1}, {:var, v}} end
  def deriv({:log, {:mul, {:var, v}, _}}, v) do {:div, {:num, 1}, {:var, v}} end

  # ln(x + 1) with chain rules
  def deriv({:log, e}, v) do {:div, deriv(e, v), e} end

  #Calculator
  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  #Simplify given expression
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:sub, e1, e2}) do
    simplify_sub(simplify(e1), simplify(e2))
  end
  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end

  #Simplify add
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  #Simplify mul
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  #Simplify exp
  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  #Simplify sub
  def simplify_sub({:num, 0}, e2) do -e2 end  #Can't -e2
  def simplify_sub(e1, {:num, 0}) do e1 end
  def simplify_sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end
  def simplify_sub(e1, e2) do {:sub, e1, e2} end

  #Simplify div
  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(_, {:num, 0}) do raise "Divided with 0" end
  def simplify_div(e, {:num, 1}) do e end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
  def simplify_div(e1, e2) do {:div, e1, e2} end

  #Pretty printing
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^#{pprint(e2)}" end
  def pprint({:sub, e1, e2}) do "(#{pprint(e1)} - #{pprint(e2)})" end
  def pprint({:div, e1, e2}) do "#{pprint(e1)} / #{pprint(e2)}" end
  def pprint({:log, e}) do "ln(#{pprint(e)})" end

end

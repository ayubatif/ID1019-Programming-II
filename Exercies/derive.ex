defmodule Deriv do
    
    def deriv({:const, _}, _) do {:const, 0} end
    def deriv({:var, v}, v) do {:const, 1} end
    def deriv({:var, y}, _) do {:const, 0} end
    
    def deriv({:mul, e1, e2}, v) do {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}} end
    def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end
    
    #TODO add clause to handle expression as base
    def deriv({:exp, {:var, v}, {:const, c}}, v) do {:mul, {:const, c}, {:exp, {:var, v}, {:const, c - 1}}} end
    def deriv({:exp, {:var, v}, e1}, v) do {:mul,{:mul, deriv(e1, v), {:exp, {:var, v}, e1}} , {:add, {:log, x, 10}, {:const, 1}}} end

    #TODO add clause for expression in log
    def deriv({:log, {:var, v}, {:const, c}}, v) do {:exp, {:mul, {:var, v}, {:ln, {:const, c}}}, {:const, -1}} end

   
    def deriv({:ln, {:var, v}, v}) do {:exp, {:var, v}, {:const, -1}} end
    def deriv({:ln, e1, v}) do {:mul, deriv(e1, v), {:exp, e1, {:const, -1}}} end



    #SIMPLIFY

    def simplify({:const, c}) do {:const, c} end
    def simplify({:var, c}) do {:var, c} end
    def simplify() end
end
defmodule Env do

#new(): return an empty environment
#add(id, str, env): return an environment where the binding of the variable id to the structure str has been added to the environment env
#lookup(id, env): return either {id, str}, if the variable id was bound, or nil
#remove(ids, env): returns an environment where all bindings for variables in the list ids have been removed

    def new() do [] end

    def add(id, str, []) do [{id, str}] end
    def add(id, str, [{id, _} | t]) do [{id, str} | t] end
    def add(id, str, [h | t]) do [h | add(id, str, t)] end

    def lookup(_, []) do nil end
    def lookup(id, [{id, str} | _]) do {id, str} end
    def lookup(id, [_ | t]) do lookup(id, t) end

    def remove([], env) do env end
    def remove([id | idz], env) do remove(idz, x_remove(id, env)) end

    def x_remove(_, []) do [] end
    def x_remove(id, [{id, _} | t]) do t end
    def x_remove(id, [h | t]) do [h | x_remove(id, t)] end

end

defmodule Eager do
    
    # return the atom
    def eval_expr({:atm, id}, _, _)  do {:ok, id} end
    
    # var return value : error
    def eval_expr({:var, id}, env, _) do
        case Env.lookup(id, env)  do
            nil ->
                :error
            {_, str} ->
                {:ok, str}
        end
    end
    
    # collection iterate
    def eval_expr({:cons, rt, lt}, env, prg) do
        case eval_expr(rt, env, prg) do
            :error ->
                :error
            {:ok, rs} ->
                case eval_expr(lt, env, prg) do
                    :error ->
                        :error
                    {:ok, ls} ->
                        {:ok, {rs, ls}}
                end
        end
    end

    def eval_match(:ignore, _, env) do {:ok, env} end
    def eval_match({:atm, id}, id, env) do {:ok, env} end
    def eval_match({:var, id}, str, env) do
        case Env.lookup(id, env) do
            nil ->
                {:ok, Env.add(id, str, env)}
            {_, ^str} ->
                {:ok, env}
            {_, _} ->
                :fail
        end
    end
    def eval_match({:cons, a, b}, {aa , bb}, env) do
        case eval_match(a, aa, env) do
            :fail ->
                :fail
            {:ok, env} ->
                eval_match(b, bb, env)
        end
    end
    def eval_match(_, _, _), do: :fail

    def eval_seq([exp], env, prg) do
        eval_expr(exp, env, prg)
    end
    def eval_seq([{:match, pattern, exp}|tail], env, prg) do
        case eval_expr(exp, env, prg) do
            :error -> 
                :error
            {:ok, str} ->
                vars = extract_vars(pattern)
                env = Env.remove(vars, env)
                case eval_match(pattern, str, env) do
                    :fail ->
                        :error
                    {:ok, env} ->
                        eval_seq(tail, env, prg)
                end 
        end
    end

    def extract_vars({:var, v}) do [{:var, v}] end
    def extract_vars({:cons, l, r}) do extract_vars(l) ++ extract_vars(r) end
    def extract_vars(_) do [] end

    def eval(seq, prg) do
        eval_seq(seq, Env.new(), prg)
    end

    def test() do
        seq = [{:match, {:var, :x}, {:atm,:a}},
        {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
        {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
        {:var, :z}]

        Eager.eval(seq, [])
    end

end  
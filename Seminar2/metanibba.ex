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

    # Evaluates a case expression
    def eval_expr({:case, expr, cls}, env, prg) do
        case eval_expr(expr, env, prg)  do
            :error -> 
                :error
            {:ok, str} ->
                eval_cls(cls, str, env, prg)
        end 
    end

    # Evaluates a lambda function
    def eval_expr({:lambda, par, free, seq}, env, prg) do
        case Env.closure(free, env) do
        :error ->
            :error
        closure ->
            {:ok, {:closure, par, seq, closure}}
        end 
    end

    # Evaluates a call to a lambda function
    def eval_expr({:apply, expr, args}, env, prg) do
        case eval_expr(expr, env, prg) do
            :error ->
                :error
            {:ok, {:closure, par, seq, closure}} ->
                case eval_args(args, env, prg) do
                    :error ->
                        :error
                    strs ->
                        env = Env.args(par, strs, closure)
                        eval_seq(seq, env, prg)
                end
        end 
    end
    # Evaluates a function call to a named function
    def eval_expr({:call, id, args}, env, prg) when is_atom(id) do
        case List.keyfind(prg, id, 0) do
            nil ->
                :error
            {_, par, seq} ->
                case eval_args(args, env, prg) do
                    :error ->
                        :error
                    strs  ->
                        env = Env.args(par, strs, [])
                        eval_seq(seq, env, prg)
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

    # Function that evaluates clauses from case
    # If no clause matches then return error
    def eval_cls([], _, _, _) do
        :error
    end
    # Go through each clause... If it matches evaluate the sequence it has.
    def eval_cls( [{:clause, ptr, seq} | cls], str, env, prg) do
        vars = extract_vars(ptr)
        env = Env.remove(vars, env)
        case eval_match(ptr, str, env) do
            :fail ->
                eval_cls(cls, str, env, prg)
            {:ok, env} ->
                eval_seq(seq, env, prg)
        end 
    end

    # Function that goes through the sequence and evaluates it.
    # And evaluates the last expression.
    def eval_seq([exp], env, prg) do
        eval_expr(exp, env, prg)
    end
    def eval_seq([{:match, pattern, exp}|tail], env, prg) do
        case eval_expr(exp, env, prg) do
           :error -> 
                :error
            {:ok, str}  ->
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
    # Function that returns a list of variables.
    def extract_vars({:var, v}) do
        [{:var, v}]
    end
    def extract_vars({:cons, lt, rt}) do
        extract_vars(lt) ++ extract_vars(rt)
    end
    def extract_vars(_) do
        []
    end

    # Main function.
    def eval(seq, prg) do
        eval_seq(seq, Env.new(), prg)
    end

    # Evaluates argument in given envirement, returns a list of structures.
    def eval_args([], _, _) do
        []
    end
    def eval_args([arg | rest], env, prg) do
        case eval_expr(arg, env, prg) do
            :error ->
                :error
            {:ok, str} ->
                [str | eval_args(rest, env, prg)]
        end
    end

    # Test function.
    def test() do
        # For testing sequence
        seq =  [{:match, {:var, :x}, {:atm,:a}},
                {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
                {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
                {:var, :z}]
        # For testing clauses
        seq2 = [{:match, {:var, :x}, {:atm, :a}},
                {:case, {:var, :x},
                    [{:clause, {:atm, :b}, [{:atm, :ops}]},
                    {:clause, {:atm, :a}, [{:atm, :yes}]}
                    ]} 
                ]
        # For testing lambda functions
        seq3 = [{:match, {:var, :x}, {:atm, :a}},
                {:match, {:var, :f},
                    {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
                {:apply, {:var, :f}, [{:atm, :b}]}
                ]
        # For testing named functions.
         prgm = [{:append, [:x, :y],
                    [{:case, {:var, :x},
                        [{:clause, {:atm, []}, [{:var, :y}]},
                        {:clause, {:cons, {:var, :hd}, {:var, :tl}},
                            [{:cons,
                                {:var, :hd},
                                {:call, :append, [{:var, :tl}, {:var, :y}]}}]
                        }] 
                    }]
                }]
                
        # For testing named functions.
        seq4 = [{:match, {:var, :x},
                    {:cons, {:atm, :a}, {:cons, {:atm, :b}, {:atm, []}}}},
                {:match, {:var, :y},
                    {:cons, {:atm, :c}, {:cons, {:atm, :d}, {:atm, []}}}},
                {:call, :append, [{:var, :x}, {:var, :y}]}
                ]

        eval(seq4, prgm)
    end

end  
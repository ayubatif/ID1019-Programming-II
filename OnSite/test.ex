defmodule Test do

  # Compute the double of a number
  def double(n) do
    n * 2
  end

  def ask() do
    2+2
    3+3
    4+4
  end

  # Convert Fahrenheit to Celsius
  def celsius(n) do
    (n-32)/18
  end

  def triangleArea(n,m) do
    n * m * 0.5
  end

  def squareArea(n,m) do
    triangleArea(n,m)*2
  end

  def circleArea(n) do
    :math.pi * n * n
  end

end

defmodule Recursive do

  def product(m,n) do
    if m == 0 do
      0
    else
      n + product(m - 1, n)
    end
  end

  def product_case(m,n) do
    case m do
      0 -> 
        0
      _ ->
        n + product_case(m - 1, n)
    end
  end

  def product_cond(m,n) do
    cond do
      m == 0 ->
        0
      m != 0 ->
        n + product_cond(m - 1, n)
    end
  end

  def product_clauses(0,_) do 0 end
  def product_clauses(m,n) do
    product_clauses(m-1,n) + n
  end

  def exp(x,n) do
    case n do
      0 -> 1
      _ -> x * product(x,n-1)
    end
  end

  def exp2(n,x) do
    cond do
      n == 1 -> x
      rem(n,2) == 0 -> exp2(x,n/2) * exp2(x,n/2)
      rem(n,2) == 1 -> x * exp2(x,n-1)
    end
  end

end

# Selection Sort

defmodule Selection do
  def sort(list) do
    do_selection(list, [])
  end

  def do_selection([head|[]], acc) do
    acc ++ [head]
  end
  def do_selection(list, acc) do
    min = min(list)
    do_selection(:lists.delete(min, list), acc ++ [min])
  end

  defp min([first|[second|[]]]) do
    smaller(first, second)
  end
  defp min([first|[second|tail]]) do
    min([smaller(first, second)|tail])
  end

  defp smaller(e1, e2) do
    if e1 <= e2 do e1 else e2 end
  end
end
IO.inspect Selection.sort([100,4,10,6,9,3]) #=> [3, 4, 6, 9, 10, 100]

# Insertion Sort

defmodule Insertion do
  def sort(list) do
    do_sort([], list)
  end

  def do_sort(_sorted_list = [], _unsorted_list = [head|tail]) do
    do_sort([head], tail)
  end
  def do_sort(sorted_list, _unsorted_list = [head|tail]) do
    insert(head, sorted_list) |> do_sort(tail)
  end
  def do_sort(sorted_list, _unsorted_list = []) do
    sorted_list
  end

  def insert(elem, _sorted_list = []) do
    [elem]
  end
  def insert(elem, sorted_list) do
    [min|rest] = sorted_list
    if min >= elem do [elem|[min|rest]] else [min|insert(elem, rest)] end
  end
end
IO.inspect Insertion.sort([1, 2, 100, 3, 4, 1, 200, 45, 6, 10]) #=> [1, 1, 2, 3, 4, 6, 10, 45, 100, 200]

# Bubble Sort

defmodule Bubble do
  def sort(list) do
    make_pass(do_sort(list, []), list)
  end

  def make_pass(bubbled_list, old_list) when bubbled_list != old_list do
    do_sort(bubbled_list, []) |> make_pass(bubbled_list)
  end
  def make_pass(bubbled_list, old_list) when bubbled_list == old_list do
    bubbled_list
  end

  def do_sort(_list = [], _acc) do
    []
  end
  def do_sort([first|[]], acc) do
    acc ++ [first]
  end
  def do_sort([first|[second|tail]], acc) do
    [new_first, new_second] = swap(first, second)
    do_sort([new_second|tail], acc ++ [new_first])
  end

  defp swap(e1, e2) do
    if e1 <= e2 do [e1, e2] else [e2, e1] end
  end
end
IO.inspect Bubble.sort([1, 2, 100, 3, 4, 1, 200, 45, 6, 10]) #=> [1, 1, 2, 3, 4, 6, 10, 45, 100, 200]

defmodule Merge do

end

defmodule Quick do

end

defmodule Reverse do

end

defmodule Fibonacci do

end

defmodule Inter do

  def toBinary() do 32 end
  def toBinary(x) do toBinary([], x) end
  def toBinary(l, 0) do l end
  def toBinary(l, x) do toBinary([rem(x,2) | l], div(x,2)) end

end

defmodule Binary do

  def toInteger(l) do toInteger(l, 0) end
  def toInteger([], f) do f end
  def toInteger([x | t], f) do toInteger(t, x + f * 2) end

end

    def closure([], _) do [] end
    def closure([free | t], env) do
        case lookup(free, env) do
            nil ->
                :error
            {id, str} ->
                [{id, str} | closure(t, env)]
        end
    end

    def args([], [], closure) do closure end
    def args([par|restp], [str|rests], closure) do [{par, str} | args(restp, rests, closure)] end
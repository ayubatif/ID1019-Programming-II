defmodule Test do
    def double(n) do
        n*2
    end


    def isort(l) do isort(l, []) end

    def isort([head|tail], []) do isort(tail, [head]) end
    def isort([], sorted) do sorted end
    def isort(list = [head|tail], sorted) do isort(tail, insert(head,sorted)) end

    def insert(element, []) do [element] end
    def insert(element, list = [head|tail]) do
            case element < head do
                true -> [element|list]
                false -> [head|insert(element,tail)]
        end
    end

    # MERGESORT

    def msort([]) do IO.puts("Empty list") end
    def msort([x]) do [x] end
    def msort(list) do    
        {left,right} = split(list, [], [])
        merge(msort(left),msort(right))
    end

    def split([], left, right) do {left, right} end
    def split([h|t], [], []) do split(t, [h], []) end
    def split([h|t], left, []) do split(t, left, [h]) end
    def split([h|t], left, right) do split(t, [h|right], left) end

    def merge(left,[]) do left end  
    def merge([],right) do right end
    def merge(left = [hl|tl], right = [hr| _]) when hl < hr do 
        [hl |merge(tl,right)]
    end
    def merge(hl, [hr|tr]) do [hr| merge(hl, tr)] end

    

end 
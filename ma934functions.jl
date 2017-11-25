# Functions used in workbook one

# Creates an array of the sequence elements for a_n+1=2a_n-(8/9)a_n-1
# Given the precision and number of terms
function q1sequence(ntype,n)
    a_seq32=zeros(ntype,n);
    a_seq32[1]=ntype(1);
    a_seq32[2]=ntype(2)/ntype(3);
    for i=2:n-1
        a_seq32[i+1]=2*a_seq32[i]-(ntype(8)/ntype(9))*a_seq32[i-1];
    end
    return(a_seq32)
end


# Function merges two arrays of length n, m and returns an array of 
# length n+m whose elements are sorted in ascending order
function mergepresorted(A::Array{Int64,1}, B::Array{Int64,1})
    if length(A) == 0
        return B
    elseif length(B) == 0
        return A
    elseif A[1] < B[1]
        return vcat([A[1]], mergepresorted(A[2:end], B))
    else
        return vcat([B[1]], mergepresorted(A, B[2:end]))
    end    
end


# A recursive function that implements the mergesort algorithm for 
# an array of integers whose length, n is a power of 2
function mergesort(A)
    n=length(A)
    if n == 1
        return A # an array of length 1 is already sorted
        else
        m=Int(n/2)
        return mergepresorted(mergeSort(A[1:m]),mergeSort(A[m+1:n]))
    end
end
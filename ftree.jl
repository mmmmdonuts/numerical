# Definition of basic Fenwick tree type
type FTree
    data::KVPair
    left::Nullable{FTree}
    right::Nullable{FTree}
end

# Constructor
FTree(data::KVPair) = FTree(data, Nullable{FTree}(), Nullable{FTree}())

# Function to build a Fenwick tree from an array of KVPair objects containing list of real numbers
function buildFTree(T::Nullable{FTree}, dataArray::Array{KVPair, 1})
    # This function constructs the tree recursively   
    if length(dataArray) == 1
        # Base case: if dataArray has lenght 1, we simply store this key-value pair in T.data
        get(T).data = dataArray[1]
    else
        # Recursive case: store the sum of the elements of dataArray in T.data and assign a key of -1, 
        # split dataArray into two parts and store the first part on T.left and
        # the second part on T.right  
        sum=0.0
        for i in 1:length(dataArray)
            sum+=dataArray[i].value
        end
        
        get(T).data = KVPair(-1, sum)
        get(T).left = Nullable{FTree}(FTree(KVPair(0,0.0)))
        get(T).right = Nullable{FTree}(FTree(KVPair(0,0.0)))
        
        m=floor(Int64, length(dataArray)/2)
        get(T).left = buildFTree(get(T).left, dataArray[1:m])        
        get(T).right = buildFTree(get(T).right, dataArray[m+1:end])
    end
    return T    
end

        
# Define list type
type LList
    data::KVPair
    next::Nullable{LList}
end

# Constructor
LList(data::KVPair) = LList(data, Nullable{LList}())

# Prepend data to list
function prepend(list::Nullable{LList}, data::KVPair) 
    new = Nullable{LList}(LList(data))
    get(new).next = list
    return new
end

# Append data to list
function append(list::Nullable{LList}, data::KVPair) 
    if(isnull(list))
        # Base case: this is the end of the list so add new node
        return Nullable{LList}(LList(data))
    else
        # Recursive case: Append the data to the remainder of the list
        get(list).next = append(get(list).next, data)
        return list
    end
end


# Function to build a list from an array of Pair objects
function buildLList(dataArray::Array{KVPair, 1})
    L = Nullable{LList}(LList(dataArray[1]))
    for i in 2:length(dataArray)
        L=append(L, dataArray[i])
    end
    return L
end


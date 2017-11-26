
#######################################
# Functions used in workbook two
#######################################


# A recursive function that traverses a list and prints out 
# the key-value pairs stored in it
function traverse(L)
    if (!isnull(L))
        print(get(L).data.key)
        print(" ")
        println(get(L).data.value)
        traverse(get(L).next)
    end
end


# Function that searches an LList for the key k and returns the 
# corresponding KVPair if it is present and a Nullable{KVPair} otherwise
function Lsearch(L,k)
    if(!isnull(L))
        if(k==get(L).data.key)
           return(get(L).data.value)
        else
            Lsearch(get(L).next,k)
        end
    else
        return(Nullable{KVPair})
    end
end     


# Function that creates a linked list of KVPairs of key values respresenting 
# the interval and their corresponding partial sum given the length of the list
# and a random seed. Function also returns the total length of [0,x_n].
function llistpartialsum(n,seed=1111)
    rng=MersenneTwister(seed)
    X=rand(rng,n)
    values=Array{KVPair}(n)
    for i=1:n
        x=sum(X[1:i])
        values[i]=KVPair(i,x)
    end
    L=Nullable{LList}()
    L=buildLList(values)
    return(L,sum(X))
end


# Recursive function that takes the LList containing the list of partial sums 
# and a random Float64 in the range [0,x_n] as inputs and returns the KVPair
# corresponding to the interval in which a specific x lies
function intervalmembership(L,k)
    if(!isnull(L))
        if(k<get(L).data.value)
           return(get(L).data.key,get(L).data.value)
        else
            intervalmembership(get(L).next,k)
        end
    else
        return(Nullable{KVPair})
    end
end     


# Recursive function that takes the Fenwick tree containing the list of partial sums and 
# a random Float64 in the range [0,x_n] as inputs and returns the KVPair corresponding 
# to the interval in which x lies
function treesearch(T::Nullable{FTree},x::Float64)
    if get(T).data.key==-1
        if x<get(T).left.value.data.value
            treesearch(get(T).left,x)
        else 
            x=x-get(T).left.value.data.value
            treesearch(get(T).right,x)
        end
    else
        return(get(T).data.key,get(T).data.value)
    end
end


# Calculates the theoretical density for N number of particles
#diffusion coefficient, D, and time, T.
function normal(N,D,t)
    L=10.0
    Nx = N*2 + 1
    dx = 2.0*L/(Nx-1)
    x = dx.*(-(Nx-1)/2:(Nx-1)/2)
    return (1.0/sqrt(2.0*pi*D*t))*exp(-x.*x/(2*D*t))
end


# Function that takes the code given in the assignment and obtains the numerical 
# particle density for N number of particles
function getdensity(N)
    L=10.0
    Nx = N*2 + 1
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    D = 1.0
    t=0.0

    r = (D/2.0)/(dx*dx)
    totalRate = 2.0*N*r
    dt = 1.0/totalRate
    T=1.0

    # This is the main loop
    while t < T
        # Pick an event
        k = rand(1:2*N)
        if k<=N
            hop = 1
            particleId = k
        else
            hop = -1
            particleId=k-N
        end
        Y[particleId]+=hop
        t+=dt
    end

    # Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return(P,X)
end


# Linked list search function that returns the key corresponding to a particular
# interval
function listsearch(L,k)
    if(!isnull(L))
        if(k<get(L).data.value)
           return(get(L).data.key)
        else
            listsearch(get(L).next,k)
        end
    else
        return(Nullable{KVPair})
    end
end     


# Function that obtains particle density using diffusion coefficients
# drawn from an exp0nential distribution. Now the intervals are not of equal
# width and the information is stored in a linked list. Thus, a linear 
# search function, listsearch(), is used to find the interval and the 
# corresponding particle that is moved. The function takes in the number 
# of particles, N.
function getdensity_list(N)
    L=10.0
    Nx = N*2 + 1
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    t=0.0

    D=1
    Dexp=randexp(N)
    Dexp=[Dexp;Dexp]
    r=(Dexp./2.0)/(dx*dx)
    totalRate = sum(r)
    dt = 1.0/totalRate
    T=1.0

    values=Array{KVPair}(2*N)
    for i=1:2*N
        x=sum(r[1:i])
        values[i]=KVPair(i,x)
    end;

    List1=Nullable{LList}
    List1=buildLList(values);

    while t < T
        # Pick an event
        interval=rand()*totalRate
        k=listsearch(List1,interval)
        if k<=N
            hop = 1
            particleId = k
        else
            hop = -1
            particleId=k-N
        end
        Y[particleId]+=hop
        t+=dt
    end

    # Calculate the estimated density of particles
    P =zeros(Float64,length(X))
    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return(P,X)
end


# Recursive function that takes the Fenwick containing the list of partial sums and 
# a random Float64 in the range [0,x_n] as inputs and returns only the key
# corresponding to the interval in which x lies
function treesearch_key(T::Nullable{FTree},x::Float64)
    if get(T).data.key==-1
        if x<get(T).left.value.data.value
            treesearch(get(T).left,x)
        else 
            x=x-get(T).left.value.data.value
            treesearch(get(T).right,x)
        end
    else
        return(get(T).data.key,get(T).data.value)
    end
end


# Function that obtains particle density using diffusion coefficients
# drawn from an exponential distribution. Now the intervals are not of equal
# width and the information is stored in a Fenwick tree. Thus, the function 
# treesearch() is used to find the interval and the corresponding particle 
# that is moved. The function takes in the number of particles, N.
function getdensity_tree(N)
    L=10.0
    Nx = N*2+1
    dx = 2.0*L/(Nx-1)
    X = dx.*(-(Nx-1)/2:(Nx-1)/2)
    Y =zeros(Int64,N)
    t=0.0

    D=1
    Dexp=randexp(N)
    Dexp=[Dexp;Dexp]
    r=(Dexp./2.0)/(dx*dx)
    totalRate = sum(r)
    dt = 1.0/totalRate
    T=1.0;

    values=Array{KVPair}(2*N)
    for i=1:2*N
        values[i]=KVPair(i,r[i])
    end;

    Tree1=Nullable{FTree}(FTree(KVPair(0,0.0)))
    Tree1=buildFTree(Tree1,values);

    # This is the main loop
    while t < T
        # Pick an event
        interval=rand()*totalRate
        k=treesearch(Tree1,interval)[1]
        if k<=N
            hop = 1
            particleId = k
        else
            hop = -1
            particleId=k-N
        end
        Y[particleId]+=hop;
        t+=dt
    end
    ;

    # Calculate the estimated density of particles
    P =zeros(Float64,length(X))

    for i in 1:length(Y)
        P[Y[i]+Int64((Nx-1)/2)+1]+=1/(N * dx)
    end
    return(P,X)
end



# Function that gives the particle density from the analytic solution found
# in 3.3
function analyticdensity(X,D=1.0,t=1.0)
    return (1/(2*D*t)^0.5)*exp(-(2/(D*t))*abs(X))
end



    







# Library for collections of distribution
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

module DistributionCollections

export DistributionBag, add!, reset!

"""
Data structure that stores a colletion of distributions
"""
struct DistributionBag{T} <: AbstractArray{T, 1}
    uniform::T      # the uniform distribution of distribution type T
    bag::Vector{T}  # the actual resizeable vector that stores the 1D Gaussians
    # default constructor
    DistributionBag{T}(uniform::T) where {T} = new(uniform, Vector{T}(undef, 0))
end

"""
    DistributionBag(uniform::T)

Outer constructor for the distribution bag

# Example

```julia-repl
julia> DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}
```
"""
DistributionBag(uniform::T) where {T} = DistributionBag{T}(uniform)

"""
    show(io,db::DistributionBag{T})

Pretty-prints a distribution bag

# Example

```julia-repl
julia> DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> print(db)
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  empty bag

julia> add!(db)
1

julia> print(db)
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]

```
"""
function Base.show(io::IO, db::DistributionBag{T}) where {T}
    println(io, "Uniform: ", db.uniform)
    if (length(db.bag) == 0)
        println(io, "  empty bag")
    else
        for i in eachindex(db.bag)
            println(io, "  [", i, "]: ", db.bag[i])
        end
    end
end

"""
    add(db::DistributionBag{T})

Adds a new distribution to the distribution bag `db` and returns a unique index

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  
```
"""
function add!(db::DistributionBag{T}) where {T}
    push!(db.bag, db.uniform)
    return (length(db.bag))
end

"""
    reset!(db::DistributionBag{T})

Resets all distribution to the uniform in the distribution bag `db`

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1] = Discrete([0.0, 1.0, 1.0, 2.0, -1.0])
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]


julia> reset!(db)

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
```
"""
function reset!(db::DistributionBag{T}) where {T}
    for i in eachindex(db.bag)
        db.bag[i] = db.uniform
    end
    return
end

"""
    getindex(db::DistributionBag{T}, i::Int64)

Retrieves the distribution at index `i` from the distribution bag `db`

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1]
 P = [0.2, 0.2, 0.2, 0.2, 0.2]
```
"""
Base.getindex(db::DistributionBag{T}, i::Int64) where {T} = db.bag[i]

"""
    setindex(db::DistributionBag{T},d::T,i::Int64)

Sets the 1D Gaussian at index `i` in the distribution bag `db` to `d`

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1] = Discrete([0.0, 1.0, 1.0, 2.0, -1.0])
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

```
"""
function Base.setindex!(db::DistributionBag{T}, d::T, i::Int64) where {T}
    db.bag[i] = d
end

"""
    firstindex(db::DistributionBag{T})

Retrieves the index of the first element of the distribution bag

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1

julia> add!(db)
2
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  
[2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1] = Discrete([0.0, 1.0, 1.0, 2.0, -1.0])
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]
  [2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[begin]
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]
```
"""
Base.firstindex(db::DistributionBag{T}) where {T} = return (1)

"""
    lastindex(db::DistributionBag{T})

Retrieves the index of the last element of the distribution bag

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1

julia> add!(db)
2
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  
[2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1] = Discrete([0.0, 1.0, 1.0, 2.0, -1.0])
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]
  [2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[end]
 P = [0.2, 0.2, 0.2, 0.2, 0.2]
```
"""
Base.lastindex(db::DistributionBag{T}) where {T} = return (length(db.bag))

"""
    size(db::DistributionBag{T})

Returns the size of the distribution bag

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1

julia> add!(db)
2
  
julia> size(db)
(2,)

```
"""
Base.size(db::DistributionBag{T}) where {T} = (length(db.bag),)

"""
    IndexStyle(db::DistributionBag{T})

Returns the indexing style that can be used for a distribuion bag
"""
Base.IndexStyle(::Type{<:DistributionBag{T}}) where {T} = IndexLinear()

"""
    eltype(db::DistributionBag{T})

Returns the element type (i.e., the distribution type) of the distribution bag

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> eltype(db)
Discrete{5}

```
"""
Base.eltype(::Type{<:DistributionBag{T}}) where {T} = T

"""
    iterate(db::DistributionBag, i=1)

Implements an iterator so a distribution bag can be used like an enumerable

# Example

```julia-repl
julia> db = DistributionBag(Discrete(5))
0-element DistributionBag{Discrete{5}}

julia> add!(db)
1

julia> add!(db)
2
  
julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
[1]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  
[2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> db[1] = Discrete([0.0, 1.0, 1.0, 2.0, -1.0])
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]

julia> db
Uniform:  P = [0.2, 0.2, 0.2, 0.2, 0.2]
  [1]:  P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]
  [2]:  P = [0.2, 0.2, 0.2, 0.2, 0.2]  

julia> for d in db
           println(d)
       end
 P = [0.0704547896272078, 0.19151597437154377, 0.19151597437154377, 0.5205943929937957, 0.025918868635908737]
 P = [0.2, 0.2, 0.2, 0.2, 0.2]     
 ```
"""
Base.iterate(db::DistributionBag{T}, i=1) where {T} = (i > length(db.bag)) ? nothing : (db.bag[i], i+1)


end
# A set of types and functions for factors over discrete variables
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

include("discrete.jl")
include("distributionbag.jl")

module Factors

export PriorDiscreteFactor, CouplingDiscreteFactor, update_msg_to_x!, update_msg_to_y!

using ..DistributionCollections
using ..DiscreteDistribution

"""
    PriorDiscreteFactor

Represent a DiscreteFactor with one message passed to a factor.
A struct that should contain 4 variables:
  - db (A DistributionBag for T)
  - x (An int64 marking the index of that factor within that distributionbag)
  - prior (The prior distribution for that factor)
  - msg_to_x (The index of the distribution in the bag, which contains the message passed to X)
"""
struct PriorDiscreteFactor{T}
    ## TODO ##
end

"""
    PriorDiscreteFactor(db::DistributionBag{Discrete{T}}, x::Int64, prior)

Creates a prior factor for a discrete variable `x` with a given prior distribution `prior`
It should add a uniform distribution as the initial value for the message to the bag and store
its index in message_to_x.

# Example

```julia-repl

julia> db = DistributionBag(Discrete(3))
0-element DistributionBag{Discrete{3}}

julia> y1 = add!(db)
1

julia> f1 = PriorDiscreteFactor(db, y1, Discrete([0.0, 100.0, 0.0]))
PriorDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
, 1,  P = [0.0, 1.0, 0.0], 2)

```
"""
PriorDiscreteFactor(db::DistributionBag{Discrete{T}}, x::Int64, prior) where {T} = ## TODO ##


"""
    update_msg_to_x!(f::PriorDiscreteFactor{T})

Updates the message from the factor `f` to the associated variable x.
Also updates the distribution of the associated variable x.

# Example

```julia-repl

julia> db = DistributionBag(Discrete(3))
0-element DistributionBag{Discrete{3}}

julia> y1 = add!(db)
1

julia> f1 = PriorDiscreteFactor(db, y1, Discrete([0.0, 100.0, 0.0]))
PriorDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
, 1,  P = [0.0, 1.0, 0.0], 2)

julia> update_msg_to_x!(f1)
 P = [0.0, 1.0, 0.0]

```
"""
function update_msg_to_x!(f::PriorDiscreteFactor{T}) where {T}
    ## TODO ##
end

"""
    CouplingDiscreteFactor

A struct that represents two coupled factors, x and y.
A struct that should contain 4 variables:
  - db (A DistributionBag for T)
  - x (An int64 marking the index of the x factor within that distributionbag)
  - y (An int64 marking the index of the y factor within that distributionbag)
  - P (A matrix storing the coupling matrix)
  - msg_to_x (The index of the distribution in the bag, which contains the message passed to X)
  - msg_to_y (The index of the distribution in the bag, which contains the message passed to Y)
"""
struct CouplingDiscreteFactor{T}
    ## TODO ##
end

"""
    CouplingDiscreteFactor(db::DistributionBag{Discrete{T}}, x::Int64, y::Int64, P::Matrix{Float64})

Creates a coupling factor for two discrete variables `x` and `y` with a given coupling matrix `P`

# Example

```julia-repl

julia> db = DistributionBag(Discrete(3))
0-element DistributionBag{Discrete{3}}

julia> y1 = add!(db)
1

julia> y2 = add!(db)
2

julia> f1 = PriorDiscreteFactor(db, y1, Discrete([0.0, 100.0, 0.0]))
PriorDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
, 1,  P = [0.0, 1.0, 0.0], 3)

julia> f2 = CouplingDiscreteFactor(db, y1, y2, Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5]))
CouplingDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
  [4]:  P = [0.3333, 0.3333, 0.3333]
  [5]:  P = [0.3333, 0.3333, 0.3333]
, 1, 2, [0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5], 4, 5)

```
"""
CouplingDiscreteFactor(db::DistributionBag{Discrete{T}}, x::Int64, y::Int64, P::Matrix{Float64}) where {T} = ## TODO ##


"""
    update_msg_to_x!(f::CouplingDiscreteFactor{T})

Updates the message from the factor `f` to the associated variable x.
Also updates the distribution of the associated variable x.

# Example

```julia-repl

julia> db = DistributionBag(Discrete(3))
0-element DistributionBag{Discrete{3}}

julia> y1 = add!(db)
1

julia> y2 = add!(db)
2

julia> f1 = PriorDiscreteFactor(db, y1, Discrete([0.0, 100.0, 0.0]))
PriorDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
, 1,  P = [0.0, 1.0, 0.0], 3)

julia> f2 = CouplingDiscreteFactor(db, y2, y1, Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5]))
CouplingDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
  [4]:  P = [0.3333, 0.3333, 0.3333]
  [5]:  P = [0.3333, 0.3333, 0.3333]
, 1, 2, [0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5], 4, 5)

julia> update_msg_to_x!(f2)
 P = [0.25, 0.5, 0.25]

```
"""
function update_msg_to_x!(f::CouplingDiscreteFactor{T}) where {T}
    ## TODO ##
end

"""
    update_msg_to_y!(f::CouplingDiscreteFactor{T})

Updates the message from the factor `f` to the associated variable y.
Also updates the distribution of the associated variable y.

# Example

```julia-repl

julia> db = DistributionBag(Discrete(3))
0-element DistributionBag{Discrete{3}}

julia> y1 = add!(db)
1

julia> y2 = add!(db)
2

julia> f1 = PriorDiscreteFactor(db, y1, Discrete([0.0, 100.0, 0.0]))
PriorDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
, 1,  P = [0.0, 1.0, 0.0], 3)

julia> f2 = CouplingDiscreteFactor(db, y1, y2, Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5]))
CouplingDiscreteFactor{3}(Uniform:  P = [0.3333, 0.3333, 0.3333]
  [1]:  P = [0.3333, 0.3333, 0.3333]
  [2]:  P = [0.3333, 0.3333, 0.3333]
  [3]:  P = [0.3333, 0.3333, 0.3333]
  [4]:  P = [0.3333, 0.3333, 0.3333]
  [5]:  P = [0.3333, 0.3333, 0.3333]
, 1, 2, [0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5], 4, 5)

julia> update_msg_to_y!(f2)
 P = [0.25, 0.5, 0.25]

```
"""
function update_msg_to_y!(f::CouplingDiscreteFactor{T}) where {T}
    ## TODO ##
end

end
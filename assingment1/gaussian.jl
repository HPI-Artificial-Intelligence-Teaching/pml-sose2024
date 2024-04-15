# Library for 1D Gaussian messages and distribution
#
# 2023 by Ralf Herbrich
# Hasso-Plattner Institute

"""
Data structure that captures the state of an normalized 1D Gaussian. 
In this represenation, we are storing the precision times mean (tau) and the 
precision (rho). This representations allows for numerically stable products of 
1D-Gaussians.

Should contain two variables:
tau and rho, both Floats, to store the natural parameters of the gaussian.
"""
struct Gaussian1D
    ##TODO##

    # default constructor
    Gaussian1D(tau, rho) = ##TODO##
end
# Initializes a standard Gaussian 
Gaussian1D() = Gaussian1D(0, 1)

"""
    Gaussian1DFromMeanVariance(μ,σ2)

Initializes a Gaussian from mean and variance.
"""
Gaussian1DFromMeanVariance(μ, σ2) = ##TODO##

"""
    mean(g)

Returns the mean of the 1D-Gaussian
```julia-repl
julia> mean(Gaussian1D(1,2))
0.5

julia> mean(Gaussian1DFromMeanVariance(1,2))
1.0
```
"""
mean(g::Gaussian1D) = ##TODO##

"""
    variance(g)

Returns the variance of the 1D-Gaussian 
```julia-repl
julia> variance(Gaussian1D(1,2))
0.5

julia> variance(Gaussian1DFromMeanVariance(1,2))
2.0
```
"""
variance(g::Gaussian1D) = ##TODO##


"""
    absdiff(g1,g2)

Computes the absolute difference of `g1` and `g2` in terms of the maximum of |tau_1-tau_2| and sqrt(|rho_1-rho_2|).
# Examples
```julia-repl
julia> absdiff(Gaussian1D(0,1),Gaussian1D(0,2))
1.0

julia> absdiff(Gaussian1D(0,1),Gaussian1D(0,3))
1.4142135623730951
```
"""
absdiff(g1::Gaussian1D, g2::Gaussian1D) = ##TODO##

"""
    *(g1,g2)

Multiplies two 1D Gaussians together and re-normalizes them
# Examples
```julia-repl
julia> Gaussian1D() * Gaussian1D()
μ = 0.0, σ = 0.7071067811865476
```
"""
function Base.:*(g1::Gaussian1D, g2::Gaussian1D)
    ##TODO##
end

"""
    /(g1,g2)

Divides two 1D Gaussians from each other
# Examples
```julia-repl
julia> Gaussian1D(0,1) / Gaussian1D(0,0.5)
μ = 0.0, σ = 1.4142135623730951
```
"""
function Base.:/(g1::Gaussian1D, g2::Gaussian1D)
    ##TODO##
end

"""
    logNormProduct(g1,g2)

Computes the log-normalization constant of a multiplication of `g1` and `g2` (the end of the equation ;))

It should be 0 if both rho variables are 0.
# Examples
```julia-repl
julia> logNormProduct(Gaussian1D() * Gaussian1D())
c = 0.28209479177387814
```
"""
function logNormProduct(g1::Gaussian1D, g2::Gaussian1D)
    ##TODO##
end

"""
    logNormRatio(g1,g2)

Computes the log-normalization constant of a division of `g1` with `g2` (the end of the equation ;))

It should be 0 if both rho variables are 0.
# Examples
```julia-repl
julia> logNormRatio(Gaussian1D(0,1) / Gaussian1D(0,0.5))
5.013256549262001
```
"""
function logNormRatio(g1::Gaussian1D, g2::Gaussian1D)
    ##TODO##
end

"""
    show(io,g)

Pretty-prints a 1D Gaussian
"""
function Base.show(io::IO, g::Gaussian1D)
    if (g.rho == 0.0)
        print(io, "μ = 0, σ = Inf")
    else
        print(io, "μ = ", mean(g), ", σ = ", sqrt(variance(g)))
    end
end
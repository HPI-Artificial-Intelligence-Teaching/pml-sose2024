# Plots for decision boundary
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

using Random
using LinearAlgebra
using Distributions
using LaTeXStrings
using Plots

"""
    sigmoid(x=0)

Returns the value of the logistic sigmoid at `x`

# Examples

```jldoctest
julia> sigmoid(1)
0.7310585786300049
```
"""
function sigmoid(x=0.5)
    return exp(x) / (1 + exp(x))
end

# plot the sigmoid function
function plot_sigmoid(; xs=-4:0.1:4.0)
    p = plot(
        xs,
        map(sigmoid, xs),
        legend=:top,
        label=L"p(1|x)",
        linewidth=3,
        color=:blue,
        xtickfontsize=14,
        ytickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
        legendfontsize=16,
    )
    plot!(xs, map(x -> 1 - sigmoid(x), xs), label=L"p(0|x)", linewidth=3, color=:red)
    ylabel!(L"p(y|x)")
    xlabel!(L"x")
    display(p)
end


plot_sigmoid()
savefig("~/Downloads/sigmoid.svg")

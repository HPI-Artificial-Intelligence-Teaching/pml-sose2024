# A framework of the SEIR model
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

include("factors.jl")
module Seir
export seir_single_time_series, display_time_series


using Plots
using LaTeXStrings
using ..Factors
using ..DistributionCollections
using ..DiscreteDistribution


"""
        seir_single_time_series
Should perform the computation presented in the assignment document.
Has 3 parameters:
    - steps: The number of time-steps to be taken into account
    - prior_probs: The prior probabilities to start the computation with
    - transition_probs: The transition probabilities

It should return the marginal distributions for each timestep as an array of discrete distributions.
"""
function seir_single_time_series(;
    steps=100,
    prior_probs=[1, 1e-6, 1e-6, 1e-6],
    transition_probs=[0.95 0.05 0.0 0.0; 0.0 0.8 0.2 0.0; 0.0 0.0 0.7 0.3; 0.0 0.0 0.0 1.0]',
)
    ## TODO ##
end

"""
        display_time_series

Given an array of distributions, it should display the 4 probabilities along
the time axis. (Hint: This should call plot/plot! 4 times ;)).

It should display the generated plot.
"""
function display_time_series(ps::Vector{Discrete{T}}) where{T}
    p = plot(
        xlabel=L"t", 
        ylabel=L"P(\mathrm{SEIR})", 
        xtickfontsize=14,
        ytickfontsize=14,
        legendfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
        legend = :bottomright)

    ## TODO ##

    display(p)
end

end
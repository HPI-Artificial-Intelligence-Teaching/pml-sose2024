# False-Positive Puzzle
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

using Plots

"""
    posterior(α=0.95,β=0.001)

Returns the posterior for a positive outcome with error probability `α` and scarcity `β`
```
"""
function posterior(α=0.95, β=0.001)
    return α * β / (α * β + (1 - α) * (1 - β))
end

# plot the posterior as a function of the accuracy
function plot_posterior_over_accuracy(; αs=0.5:0.01:1.0)
    p = plot(
        αs,
        map(α -> posterior(α, 0.001), αs),
        legend=false,
        linewidth=3,
        yaxis=:log,
    )
    scatter!(αs, map(α -> posterior(α), αs))
    ylabel!("P(disease|positive test)")
    xlabel!("test accuracy")
    display(p)
end

# plot the posterior as a function of the scarcity
function plot_posterior_over_scarcity(; βs=0.001:0.01:0.5)
    p = plot(
        βs,
        map(β -> posterior(0.95, β), βs),
        legend=false,
        linewidth=3,
        xaxis=:log,
    )
    scatter!(βs, map(β -> posterior(0.95, β), βs))
    ylabel!("P(disease|positive test)")
    xlabel!("scarcity")
    display(p)
end


plot_posterior_over_accuracy()
savefig("~/Downloads/posterior_over_accuracy.svg")
plot_posterior_over_scarcity()
savefig("~/Downloads/posterior_over_scarcity.svg")

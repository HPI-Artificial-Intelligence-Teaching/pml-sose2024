# Plots for geometry of linear classification
#
# 2023 by Ralf Herbrich
# Hasso-Plattner Institute

using Plots
using LaTeXStrings
using Distributions

"""
    plot_probit()

Plots the probit function
"""
function plot_probit(; λ = 1, show_λ = false, filename = "~/Downloads/probit.svg")
    # plot the sigmoid function
    xs = range(start = -4, stop = 4, length = 500)
    p = plot(
        legend = false,
        xtickfontsize = 14,
        ytickfontsize = 14,
        xguidefontsize = 16,
        yguidefontsize = 16,
    )
    # Note that 1 - cdf(Normal(x, 1/λ),0) = 1 - cdf(Normal(x*λ, 1),0) = cdf(Normal(0,1), x*λ)
    plot!(xs, map(x -> 1 - cdf(Normal(x, 1 / λ), 0), xs), linewidth = 3)
    ylims!((0, 1))
    if (show_λ)
        λ = round(λ, digits = 1)
        ylabel!(L"g(%$λ x)")
        xlabel!(L"x")
        display(p)
    else
        ylabel!(L"g(x)")
        xlabel!(L"x")
        display(p)
        savefig(filename)
    end
end

"""
    plot_probit_video(;λ_start=-5, λ_end=5, filename="~/Downloads/anim_probit.gif")

Plots the probit function with a video of how it grows (from 2^`λ_start` to 2^`λ_end`)
"""
function plot_probit_video(;
    λ_start = -1,
    λ_end = 6,
    filename = "~/Downloads/anim_probit.gif",
)
    gr()
    anim = @animate for λ ∈ range(λ_start, λ_end, length = 200)
        plot_probit(λ = 2^λ, show_λ = true)
    end
    gif(anim, filename, fps = 10)

end

plot_probit()
plot_probit_video()

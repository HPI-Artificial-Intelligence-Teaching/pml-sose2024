# Plots for polynomial regression
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

using Random
using LinearAlgebra
using Distributions
using LaTeXStrings
using Plots

"""
    generate_data(n, f, σ=0.1)

Generates a dataset of n observatiosn using a given function f with additive, zero-mean Gaussian noise with standard deviation of σ
"""
function generate_data(n::Int64, f; σ=0.1, from=0, to=1)
    xs = collect(range(from, to, n))
    ys = map(f, xs) + randn((n, 1)) * σ
    return (x=xs, y=ys)
end

"""
    generate_features(data)

Generates the ferature matrix from the raw data
"""
function generate_features(data; max_degree=2, min_degree=1)
    return hcat([data .^ i for i = min_degree:max_degree]...)
end

"""
    fit_polynomial(train_data; degree=2, min_degree=1, color=:blue)

Generates a least-square fit of a polynomial of degree and plots the fit
"""
function fit_polynomial(
    train_data;
    degree=2,
    min_degree=1,
    color=:blue,
    threed=false,
)
    train_X = generate_features(train_data.x, min_degree=min_degree, max_degree=degree)
    w = inv(train_X' * train_X) * train_X' * train_data.y
    xs = collect(range(minimum(train_data.x), maximum(train_data.x), 100))
    test_X = generate_features(xs, min_degree=min_degree, max_degree=degree)
    ys = test_X * w
    if (threed)
        plot!(xs, ys, zeros(100), linewidth=3, color=color)
    else
        plot!(xs, ys, linewidth=3, color=color)
    end
    return w
end

"""
    likelihood(w, X, y; σ = 0.15)

Computes the likelihood of N(y|Xw,σ^2 ⋅ I)
"""
function likelihood(w, X, y; σ=0.15)
    return pdf(MvNormal(X * w, I * σ^2), y)[1]
end

# plot of the training data
function plot_training_data()
    p = plot(
        train_data.x,
        train_data.y,
        seriestype=:scatter,
        legend=false,
        color=:orange,
        xtickfontsize=14,
        ytickfontsize=14,
        ztickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
        zguidefontsize=16,
    )
    xlabel!(L"x")
    ylabel!(L"y")
    return p
end

# plot of the training data with best fit of n-th order polynomial
function plot_polynomial_fit(min_degree=1, degree=2)
    p = plot_training_data()
    w_best =
        fit_polynomial(train_data, min_degree=min_degree, degree=degree, color=:blue)
    display(p)
    return w_best

end

# do a 2D surface plot
function plot_2D_surface(
    f;
    w1_range=range(-5, stop=5, length=100),
    w2_range=range(-5, stop=5, length=100),
    w1_coarse_range=range(-5, stop=5, length=40),
    w2_coarse_range=range(-5, stop=5, length=40),
    color=:blues,
)
    p = surface(
        w1_range,
        w2_range,
        (w1, w2) -> f([w1, w2]),
        color=color,
        fillalpha=0.9,
        legend=false,
        xtickfontsize=14,
        ytickfontsize=14,
        ztickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
        zguidefontsize=16,
    )
    # wireframe!(
    #     w1_coarse_range,
    #     w2_coarse_range,
    #     (w1, w2) -> f([w1, w2]),
    #     overdraw = true, 
    #     transparency = true,
    # )
    xlabel!(L"w_1")
    ylabel!(L"w_2")
    display(p)
end

function plot_predictive_distribution(train_data, w_best)
    # plot the predictive distribution
    x = range(0, stop=maximum(train_data.x), length=100)
    y = range(minimum(train_data.y), stop=maximum(train_data.y), length=100)
    x_coarse = range(minimum(train_data.x), stop=maximum(train_data.x), length=30)
    y_coarse =
        range(1.5 * minimum(train_data.y), stop=1.5 * maximum(train_data.y), length=30)
    p = plot(train_data.x, train_data.y, zeros(11), seriestype=:scatter, color=:orange)
    fit_polynomial(train_data, min_degree=1, degree=2, color=:blue, threed=true)
    surface!(
        x,
        y,
        (x, y) -> pdf(Normal(w_best[1] * x + w_best[2] * x * x, 0.15), y),
        color=:greys,
        fillalpha=0.5,
        legend=false,
        xtickfontsize=14,
        ytickfontsize=14,
        ztickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
        zguidefontsize=16,
    )
    # wireframe!(
    #     x_coarse,
    #     y_coarse,
    #     (x, y) -> pdf(Normal(w_best[1] * x + w_best[2] * x * x, 0.15), y),
    # )
    xlabel!(L"x")
    ylabel!(L"y")
    display(p)
end


# generates training data 
Random.seed!(41)
train_data = generate_data(11, x -> sin(x * π), σ=0.15, from=0, to=1)
# train_data = generate_data(11, x -> 1/(1+x^2), σ=0.05, from=-5, to=5)
# train_data = generate_data(11, x -> sin(x * π) * cos(x * π), σ = 0.15, from = 0, to = 1)

# do all the plots
p = plot_training_data()
display(p)
savefig("~/Downloads/training_data.svg")

w_best = plot_polynomial_fit(1, 2)
savefig("~/Downloads/polynomial_fit_1_2.svg")
plot_polynomial_fit(0, 6)
savefig("~/Downloads/polynomial_fit_0_6.svg")
plot_polynomial_fit(0, 10)
savefig("~/Downloads/polynomial_fit_0_10.svg")


# plot the prior over the weight space
mv = MvNormal([0, 0], I * 2)
plot_2D_surface(w -> pdf(mv, w))
savefig("~/Downloads/prior.png")

# plot the likelihood over the weight space
train_X = generate_features(train_data.x, min_degree=1, max_degree=2)
plot_2D_surface(
    w -> likelihood(w, train_X, train_data.y),
    w1_range=range(3, stop=5, length=100),
    w2_range=range(-5, stop=-3, length=100),
    w1_coarse_range=range(3, stop=5, length=30),
    w2_coarse_range=range(-5, stop=-3, length=30),
    color=:reds,
)
savefig("~/Downloads/likelihood.png")

plot_2D_surface(
    w -> likelihood(w, train_X, train_data.y) * pdf(mv, w),
    w1_range=range(3, stop=5, length=100),
    w2_range=range(-5, stop=-3, length=100),
    w1_coarse_range=range(3, stop=5, length=30),
    w2_coarse_range=range(-5, stop=-3, length=30),
    color=:greens,
)
savefig("~/Downloads/posterior.png")

plot_predictive_distribution(train_data, w_best)
savefig("~/Downloads/predictive_distribution.png")
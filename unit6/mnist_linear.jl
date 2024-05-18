# Plots for linear algebra with RBG vectors
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

using LinearAlgebra
using LaTeXStrings
using Plots
using MLDatasets

# plots a single MNIST digit
function plot_MNIST_digit(digit; inset=:nothing, subplot=:nothing)
    img = hcat(map(r -> r[28:-1:1], eachrow(reshape(digit[(28*28):-1:1], 28, 28)'))...)'

    if inset == :nothing
        return heatmap(1 .- img,
            colormap=:grays,
            legend=false,
            aspect_ratio=:equal,
            xaxis=nothing,
            yaxis=nothing,
            bordercolor=:white,
            xlim=(0, 28),
            ylim=(0, 28),
            clim=(0, 1),
        )
    else
        return heatmap!(1 .- img,
            colormap=:grays,
            legend=false,
            aspect_ratio=:equal,
            xaxis=nothing,
            yaxis=nothing,
            bordercolor=:white,
            inset=inset,
            subplot=subplot,
            xlim=(0, 28),
            ylim=(0, 28),
            clim=(0, 1),
        )
    end
end

# plots a grid of linear combinations of MNIST digits
function plot_MNIST_grid(; idx1=1, idx2=4, N=10)
    x1 = MNIST(split=:train).features[:, :, idx1]
    x2 = MNIST(split=:train).features[:, :, idx2]
    p = plot(
        xlim=(-0.1, 1.1),
        ylim=(-0.1, 1.1),
        legend=false,
        xtickfontsize=14,
        ytickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
    )
    xlabel!(L"\alpha_1")
    ylabel!(L"\alpha_2")
    idx = 2
    for α1 in range(0, 1.0 - 8.0 / 5.0N, N)
        for α2 in range(0, 1.0 - 8.0 / 5.0N, N)
            plot_MNIST_digit(α1 * x1 + α2 * x2,
                inset=(1, bbox(α1 + 1.0 / 2.0N, α2 + 1.0 / 2.0N, 5.0 / 8.0N, 5.0 / 8.0N, :bottom, :left)),
                subplot=idx,
            )
            idx += 1
        end
    end
    display(p)
end

# plots a grid of linear combinations of MNIST digits
function plot_MNIST_SVD(; N=1000, k=5, idx=2, base_filename="~/Downloads/mnist_svd")
    data = MNIST(split=:train)
    X = hcat(map(i -> data.features[:, :, i][:], 1:N)...)'
    U, Σ, V = svd(X)

    p = plot(
        xlim=(-0.1, 1.1),
        ylim=(-0.1, 1.1),
        legend=false,
        xtickfontsize=14,
        ytickfontsize=14,
        xguidefontsize=16,
        yguidefontsize=16,
    )

    A = Diagonal(Σ[1:k]) * V[:, 1:k]'
    println(size(A))
    for i in 1:k
        display(plot_MNIST_digit(A[i, :]))
        savefig(base_filename * "_base_$i.svg")
    end

    display(plot_MNIST_digit(X[idx, :]))
    savefig(base_filename * "_original_$idx.svg")
    display(plot_MNIST_digit(U[idx, 1:k]' * A))
    savefig(base_filename * "_reconstruction_$idx.svg")
end

# computes the matrix that rotates the content of a 28x28 MNIST digit image
function compute_MNIST_rotation_matrix(; α=π / 2)
    N = 28
    A = zeros(N * N, N * N)

    # sets the element of the matrix A
    function set(idx, row, col, value)
        if row > 0 && row <= N && col > 0 && col <= N
            A[idx, round(Int, (row - 1) * 28 + col)] = value
        end
    end

    # compute the four source pixel for each target pixel and the bilinear interpolation
    for row in 1:N
        for col = 1:N
            idx = (row - 1) * N + col
            x, y = col - 14.5, row - 14.5
            γ = atan(y, x)
            r = sqrt(x^2 + y^2)
            src_col, src_row = 14.5 + cos(γ + α) * r, 14.5 + sin(γ + α) * r

            # set the four pixels that contriubute to the bilinear interpolation
            set(idx, floor(src_row), floor(src_col), (ceil(src_row) - src_row) * (ceil(src_col) - src_col))
            set(idx, floor(src_row), ceil(src_col), (ceil(src_row) - src_row) * (src_col + 1.0 - ceil(src_col)))
            set(idx, ceil(src_row), floor(src_col), (src_row + 1.0 - ceil(src_row)) * (ceil(src_col) - src_col))
            set(idx, ceil(src_row), ceil(src_col), (src_row + 1.0 - ceil(src_row)) * (src_col + 1.0 - ceil(src_col)))
        end
    end

    return A
end

# generates all the plots for a linear mapping
function plot_MNIST_rotation_matrix(; idx=5, base_filename="~/Downloads/")
    img = MNIST(split=:train).features[:, :, idx][:]

    # save the image with a rotation of +/- 22.5 degrees
    display(plot_MNIST_digit(img))
    savefig(base_filename * "original_$idx.svg")
    display(plot_MNIST_digit(compute_MNIST_rotation_matrix(α=π / 16) * img))
    savefig(base_filename * "rotated_pi_16_$idx.svg")
    display(plot_MNIST_digit(compute_MNIST_rotation_matrix(α=-π / 16) * img))
    savefig(base_filename * "rotated_minus_pi_16_$idx.svg")

    # save the rotation matrix
    A = compute_MNIST_rotation_matrix(α=π / 16)
    p = heatmap(1 .- A,
        colormap=:grays,
        legend=false,
        aspect_ratio=:equal,
        xaxis=nothing,
        yaxis=nothing,
        bordercolor=:white,
        xlim=(0, 28 * 28),
        ylim=(0, 28 * 28),
        clim=(0, 1),
    )
    display(p)
    savefig(base_filename * "rotation_matrix_plus_pi_16.svg")

    A = compute_MNIST_rotation_matrix(α=-π / 16)
    p = heatmap(1 .- A,
        colormap=:grays,
        legend=false,
        aspect_ratio=:equal,
        xaxis=nothing,
        yaxis=nothing,
        bordercolor=:white,
        xlim=(0, 28 * 28),
        ylim=(0, 28 * 28),
        clim=(0, 1),
    )
    display(p)
    savefig(base_filename * "rotation_matrix_minus_pi_16.svg")

    # make a movie of rotated images
    anim = Animation()
    for α in range(0, 2π, length=120)
        p = plot_MNIST_digit(compute_MNIST_rotation_matrix(α=α) * img)
        frame(anim, p)
    end

    mp4(anim, base_filename * "rotation_movie.mp4", fps=30)
end


plot_MNIST_grid()
savefig("~/Downloads/mnist_linear.svg")

plot_MNIST_SVD()

plot_MNIST_rotation_matrix()
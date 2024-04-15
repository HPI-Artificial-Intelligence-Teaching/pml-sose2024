include("gaussian.jl")

using Test

# Test mean function
@testset "mean function" begin
    g = Gaussian1D(1.0, 2.0)
    g_μσ = Gaussian1DFromMeanVariance(1, 2)

    @test mean(g) == 0.5
    @test mean(g_μσ) == 1.0
end

# Test variance function
@testset "variance function" begin
    g = Gaussian1D(1.0, 2.0)
    g_μσ = Gaussian1DFromMeanVariance(1, 2)
    @test variance(g) == 0.5
    @test variance(g_μσ) == 2.0
end

# Test absdiff function
@testset "absdiff function" begin
    g1 = Gaussian1D(0.0, 1.0)
    g2 = Gaussian1D(0.0, 2.0)
    @test absdiff(g1, g2) == 1.0

    g3 = Gaussian1D(1.0, 1.0)
    g4 = Gaussian1D(2.0, 3.0)

    @test absdiff(g3, g4) ≈ sqrt(2)
end

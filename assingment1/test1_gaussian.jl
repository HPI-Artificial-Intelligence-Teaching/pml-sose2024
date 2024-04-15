include("gaussian.jl")

using Test

# Test Gaussian1D constructor without input
@testset "Gaussian1D constructor without input" begin
    g = Gaussian1D()
    @test g.tau == 0
    @test g.rho == 1.0
end

# Test Gaussian1D constructor with valid input
@testset "Gaussian1D and Gaussian1DFromMeanVariance constructor with valid input" begin
    g = Gaussian1D(1.0, 2.0)
    g_μσ2 = Gaussian1DFromMeanVariance(1.0, 2.0)
    @test g.tau == 1.0
    @test g.rho == 2.0
    @test g_μσ2.tau == 0.5
    @test g_μσ2.rho == 0.5
end

# Test Gaussian1D constructor with negative precision
@testset "Gaussian1D and Gaussian1DFromMeanVariance constructor with negative precision" begin
    @test_throws ErrorException Gaussian1D(1.0, -2.0)
    @test_throws ErrorException Gaussian1DFromMeanVariance(1.0, -2.0)
end

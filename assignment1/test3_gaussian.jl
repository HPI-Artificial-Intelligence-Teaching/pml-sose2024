include("gaussian.jl")

using Test

# Test * operator
@testset "* operator" begin
    g1 = Gaussian1D(0.0, 1.0)
    g2 = Gaussian1D(2.0, 0.5)

    result = g1 * g2
    @test result.tau == 2.0
    @test result.rho == 1.5
end

# Test / operator
@testset "/ operator" begin
    g1 = Gaussian1D(1.0, 2.0)
    g2 = Gaussian1D(0.5, 0.5)
    result = g1 / g2
    @test result.tau == 0.5
    @test result.rho == 1.5
end

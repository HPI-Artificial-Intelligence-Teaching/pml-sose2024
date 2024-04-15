include("gaussian.jl")

using Test

@testset "logNormProduct function" begin
    g1 = Gaussian1D(0, 1)
    g2 = Gaussian1D(5, 9)
    @test logNormProduct(g1, g2) ≈ -1.1105076799224747 atol = 0.0001
    @test logNormProduct(g2, g1) ≈ -1.1105076799224747 atol = 0.0001
    g1 = Gaussian1D(1, 2)
    @test logNormProduct(g2, g1) ≈ -0.6752255431810281 atol = 0.0001
end

@testset "logNormRatio function" begin
    g1 = Gaussian1D(0, 9)
    g2 = Gaussian1D(5, 1)
    @test logNormRatio(g1, g2) ≈ 15.040330051032864 atol = 0.0001
    g2 = Gaussian1D(-2, 9)
    @test logNormRatio(g1, g2) ≈ 0.0
    g1 = Gaussian1D(2, 10)
    @test logNormRatio(g1, g2) ≈ 8.993841013255816 atol = 0.0001
end

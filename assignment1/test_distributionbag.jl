include("discrete.jl")
include("distributionbag.jl")

using .DiscreteDistribution
using .DistributionCollections
using Test

@testset "Create a distributionbag of 5 element discrete distributions" begin
    d = Discrete(5)
    b = DistributionBag(d)
    @test b.uniform == d
end

@testset "Add an initial distribution to a distributionbag" begin
    d = Discrete(5)
    b = DistributionBag(d)
    add!(b)
    @test b.bag[1] == d
end


@testset "Set distribution at position in a distributionbag" begin
    d = Discrete(5)
    d2 = Discrete([0.2, 0.2, 0.2, 0.2, 0.2])
    b = DistributionBag(d)
    add!(b)
    b[1] = d2
    @test b.bag[1] == d2
end

@testset "Reset distributions in a distributionbag" begin
    d = Discrete(5)
    d2 = Discrete([0.2, 0.2, 0.2, 0.2, 0.2])
    b = DistributionBag(d)
    add!(b)
    b[1] = d2
    reset!(b)
    @test b.bag[1] == d
end

@testset "Firstindex returns 1" begin
    d = Discrete(5)
    b = DistributionBag(d)
    @test firstindex(b) == 1
end

@testset "Set distribution at position in a distributionbag" begin
    d = Discrete(5)
    b = DistributionBag(d)
    add!(b)
    add!(b)
    @test lastindex(b) == 2
end

@testset "Set distribution at position in a distributionbag" begin
    d = Discrete(5)
    b = DistributionBag(d)
    add!(b)
    add!(b)
    @test size(b) == (2,)
end

@testset "Set distribution at position in a distributionbag" begin
    d = Discrete(5)
    b = DistributionBag(d)
    @test eltype(b) == Discrete{5}
end

@testset "Set distribution at position in a distributionbag" begin
    d = Discrete(5)
    d2 = Discrete([0.2, 0.2, 0.2, 0.2, 0.2])
    b = DistributionBag(d)
    add!(b)
    add!(b)
    b[1] = d2

    dists = [d2, d]
    collected = collect(b)
    @test dists == collected
end
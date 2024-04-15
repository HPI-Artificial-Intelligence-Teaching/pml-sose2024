using Test

@testset "Gaussian1D tests" begin
    include("test1_gaussian.jl")
    include("test2_gaussian.jl")
    include("test3_gaussian.jl")
    include("test4_gaussian.jl")
end
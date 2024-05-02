include("factors.jl")

using Test
using .Factors
using .DistributionCollections
using .DiscreteDistribution

@testset "Initialize a prior discrete factor" begin
    db = DistributionBag(Discrete(3))
    y1 = add!(db)
    prior = Discrete([0.0, 100.0, 0.0])
    f1 = PriorDiscreteFactor(db, y1, prior)

    @test f1.x == y1
    @test f1.db == db
    @test f1.prior == prior
    @test f1.msg_to_x == 2
    @test ℙ(f1.db[1]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
    @test ℙ(f1.db[2]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
end

@testset "Update a passed message on a discrete factor" begin
    db = DistributionBag(Discrete(3))
    y1 = add!(db)
    prior = Discrete([0.0, 100.0, 0.0])
    f1 = PriorDiscreteFactor(db, y1, prior)

    @test ℙ(f1.db[1]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
    @test ℙ(f1.db[2]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
    return_val = update_msg_to_x!(f1)
    @test f1.x == 1
    @test f1.db == db
    @test f1.prior == prior
    @test f1.msg_to_x == 2
    @test ℙ(f1.db[1]) ≈ [0, 1, 0] atol = 0.00001
    @test ℙ(f1.db[2]) ≈ [0, 1, 0] atol = 0.00001
    @test return_val == prior
end

@testset "Initialize a coupling discrete factor" begin
    db = DistributionBag(Discrete(3))
    y1 = add!(db)
    y2 = add!(db)
    p = Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5])
    f1 = CouplingDiscreteFactor(db, y1, y2, p)

    @test f1.db == db
    @test f1.x == y1 == 1
    @test f1.y == y2 == 2
    @test length(db) == 4
    @test f1.msg_to_x == 3
    @test f1.msg_to_y == 4
end

@testset "Update a passed message for y on a coupling factor" begin
    db = DistributionBag(Discrete(3))
    p1 = add!(db) # 1
    p2 = add!(db) # 2
    f1 = PriorDiscreteFactor(db, p1, Discrete([0.0, 100.0, 0.0])) # Prior becomes 3
    p = Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5]) # Messages x y become 4 and 5
    f2 = CouplingDiscreteFactor(db, p1, p2, p)

    @test ℙ(f2.db[2]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
    @test ℙ(f2.db[5]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001

    update_msg_to_x!(f1)
    return_val = update_msg_to_y!(f2)
    @test f2.y == 2
    @test f2.msg_to_y == 5
    @test ℙ(f2.db[2]) ≈ [0.25, 0.5, 0.25] atol = 0.00001
    @test ℙ(f2.db[5]) ≈ [0.25, 0.5, 0.25] atol = 0.00001
    @test ℙ(return_val) ≈ [0.25, 0.5, 0.25] atol = 0.00001
end

@testset "Update a passed message for x on a coupling factor" begin
    db = DistributionBag(Discrete(3))
    p1 = add!(db)
    p2 = add!(db)
    f1 = PriorDiscreteFactor(db, p1, Discrete([0.0, 100.0, 0.0]))
    p = Matrix([0.5 0.25 0.25; 0.25 0.5 0.25; 0.25 0.25 0.5])
    f2 = CouplingDiscreteFactor(db, p2, p1, p)

    @test ℙ(f2.db[2]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001
    @test ℙ(f2.db[4]) ≈ [0.3333333333333333, 0.3333333333333333, 0.3333333333333333] atol = 0.00001

    update_msg_to_x!(f1)
    return_val = update_msg_to_x!(f2)
    @test f2.x == 2
    @test f2.msg_to_x == 4
    @test ℙ(f2.db[2]) ≈ [0.25, 0.5, 0.25] atol = 0.00001
    @test ℙ(f2.db[4]) ≈ [0.25, 0.5, 0.25] atol = 0.00001
    @test ℙ(return_val) ≈ [0.25, 0.5, 0.25] atol = 0.00001
end
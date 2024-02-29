using Test
include("dual.jl")

@testset "Equal" begin
    @test Dual{Int64}(1, 3) == Dual{Int64}(1, 3)
    @test !(Dual{Int64}(1, 3) == Dual{Int64}(2, 3))
end

@testset "Unequal" begin
    @test Dual{Int64}(1, 3) != Dual{Int64}(2, 3)
    @test !(Dual{Int64}(1, 3) != Dual{Int64}(1, 3))
end

@testset "Conjugate" begin
    @test conj(Dual{Int64}(1, 3)) == Dual{Int64}(1, -3)
end

@testset "Invert sign" begin
    @test -Dual{Int64}(1, 3) == Dual{Int64}(-1, -3)
end

@testset "Add" begin
    @test Dual{Int64}(1, 3) + Dual{Int64}(-1, -3) == Dual{Int64}(0, 0)
    @test Dual{Int64}(1, 3) + Dual{Int64}(3, 2) == Dual{Int64}(4, 5)
end

@testset "Subtract" begin
    @test Dual{Int64}(1, 3) - Dual{Int64}(-1, -3) == Dual{Int64}(2, 6)
    @test Dual{Int64}(1, 3) - Dual{Int64}(3, 2) == Dual{Int64}(-2, 1)
end

@testset "Multiply" begin
    @test Dual{Int64}(1, 3) * Dual{Int64}(2, 4) == Dual{Int64}(2, 10)
    @test Dual{Int64}(1, 3) * Dual{Int64}(-3, -2) == Dual{Int64}(-3, -11)
end

@testset "Division" begin
    @test Dual{Float64}(15.0, 3.0) / Dual{Float64}(5.0, 1.0) == Dual{Float64}(3.0, 0.0)
end

@testset "Display" begin
    @test display(Dual{Int64}(4, 6)) == "4 + 6ε"
    @test display!(Dual{Int64}(4, 6)) == "4 + 6ε"
end

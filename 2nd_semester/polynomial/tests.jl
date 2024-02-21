using Test
include("polynomial.jl")

@testset "Constructor" begin
    @test Polynomial{Int64}([0, 2, 3, 4, 0]) == Polynomial{Int64}([0, 2, 3, 4])
    @test Polynomial{Int64}([0, 0, 2, 3, 4, 0, 1]) == Polynomial{Int64}([0, 0, 2, 3, 4, 0, 1])
end

@testset "Equal" begin
    @test Polynomial{Int64}([2, 3, 4, 0]) == Polynomial{Int64}([2, 3, 4, 0])
    @test !(Polynomial{Int64}([0, 2, 3, 1]) == Polynomial{Int64}([0, 2, 3, 4]))
end

@testset "Unequal" begin
    @test !(Polynomial{Int64}([0, 2, 3, 4]) != Polynomial{Int64}([0, 2, 3, 4]))
    @test Polynomial{Int64}([0, 2, 3, 1]) != Polynomial{Int64}([0, 2, 3, 4])
end

@testset "Order" begin
    @test ord(Polynomial{Int64}([0, 0, 0, 0, 3, 4, 5, 6, 0, 0, 0])) == 7
end

@testset "Invert sign" begin
    @test -Polynomial{Int64}([0, 2, 3, 5]).coeffs == Polynomial{Int64}([0, -2, -3, -5]).coeffs
end

@testset "Add" begin
    @test Polynomial{Int64}([0, 2, 3, 5]) + Polynomial{Int64}([1, 2, 3, 0]) == Polynomial{Int64}([1, 4, 6, 5])
    @test Polynomial{Int64}([1, 2, 3, 4]) + Polynomial{Int64}([-1, -2, -3, -4]) == Polynomial{Int64}([0])
end

@testset "Subtract" begin
    @test Polynomial{Int64}([0, 2, 3, 5]) - Polynomial{Int64}([1, 2, 3, 0]) == Polynomial{Int64}([-1, 0, 0, 5])
    @test Polynomial{Int64}([1, 2, 3, 4]) - Polynomial{Int64}([1, 2, 3, 4]) == Polynomial{Int64}([0])

end

@testset "Multiply" begin
    @test Polynomial{Int64}([0, 2, 3, 5]) * Polynomial{Int64}([1, 2, 3, 0]) == Polynomial{Int64}([0, 2, 7, 17, 19, 15])
end

@testset "Div" begin
    @test Polynomial{Float64}([2.0, 0.0, 6.0, 0.0, 1.0]) / Polynomial{Float64}([5.0, 0.0, 1.0]) == (Polynomial{Float64}([1.0, 0.0, 1.0]), Polynomial{Float64}([-3.0]))
end

@testset "Rem" begin end

@testset "Divrem" begin end

@testset "Value" begin
    @test value(Polynomial{Int64}([0, 2, 3, 5]), 0) == 0
    @test value(Polynomial{Int64}([0, 2, 3, 5]), 1) == 10
    @test value(Polynomial{Int64}([0, 2, 3, 5]), 2) == 56
end

@testset "Derivative" begin
    @test derivative(Polynomial{Int64}([0, 2, 3, 5]), 0) == value(Polynomial{Int64}([2, 6, 15]), 0)
    @test derivative(Polynomial{Int64}([0, 2, 3, 5]), 1) == value(Polynomial{Int64}([2, 6, 15]), 1)
    @test derivative(Polynomial{Int64}([0, 2, 3, 5]), 2) == value(Polynomial{Int64}([2, 6, 15]), 2)
end

@testset "Display" begin
    @test display(Polynomial{Int64}([0, 2, 3, 5])) == "5x^3 + 3x^2 + 2x"
    @test display!(Polynomial{Int64}([0, 2, 3, 5])) == "5x^3 + 3x^2 + 2x"
    @test display!(Polynomial{Int64}([1, 2, 3, 5])) == "5x^3 + 3x^2 + 2x + 1"
end
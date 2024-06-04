using Test
include("./lib.jl")

function main()
    # Test next_repit_placement!
    @testset "next_repit_placement!" begin
        p = [1, 1, 1]
        next_repit_placement!(p, 3)
        @test p == [1, 1, 2]
    end

    # Test next_permute!
    @testset "next_permute!" begin
        p = [1, 2, 3, 4]
        next_permute!(p)
        @test p == [1, 2, 4, 3]
    end

    # Test first_split! and next_split!
    @testset "first_split! and next_split!" begin
        s = [0, 0, 0]
        first_split!(s, 3, 3)
        @test s == [3, 0, 0]
        next_split!(s, 3)
        @test s == [2, 1, 0]
        next_split!(s, 3)
        @test s == [2, 0, 1]
        next_split!(s, 3)
        @test s == [1, 2, 0]
        next_split!(s, 3)
        @test s == [1, 1, 1]
        next_split!(s, 3)
        @test s == [1, 0, 2]
        next_split!(s, 3)
        @test s == [0, 3, 0]
        next_split!(s, 3)
    end

    # Test RepitPlacement
    @testset "RepitPlacement" begin
        rp = RepitPlacement{3,2}()
        @test collect(rp) == [[1, 1], [1, 2], [1, 3], [2, 1], [2, 2], [2, 3], [3, 1], [3, 2], [3, 3]]
    end

    # Test Permute
    @testset "Permute" begin
        perm = Permute{3}()
        @test collect(perm) == [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
    end

    # Test Subsets
    @testset "Subsets" begin
        sub = Subsets{3}()
        @test collect(sub) == [[false, false, false], [true, false, false], [false, true, false], [true, true, false], [false, false, true], [true, false, true], [false, true, true], [true, true, true]]
    end

    # Test KSubsets
    @testset "KSubsets" begin
        ksub = KSubsets{3,2}()
        @test collect(ksub) == [[false, true, true], [true, false, true], [true, true, false], [false, true, false], [true, false, false], [true, true, true]]
    end

    # Test NSplit
    @testset "NSplit" begin
        nsplit = NSplit{3}()
        @test collect(nsplit) == [[3], [2, 1], [1, 2], [1, 1, 1]]
    end

    # Test dfs and bfs
    @testset "dfs and bfs" begin
        graph = Dict(1 => [2, 3], 2 => [1, 4, 5], 3 => [1, 6], 4 => [2], 5 => [2], 6 => [3])
        @test dfs(graph, 1) === nothing
        @test bfs(graph, 1) === nothing
    end
end

main()
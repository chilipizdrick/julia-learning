using LinearAlgebra
include("lib.jl")

function main()
    # 1
    m = [1.0 2.0 7.5 6.5 9.0 1.5;
        0.0 3.0 2.5 0.5 7.0 3.5;
        0.0 0.0 5.5 3.5 1.0 4.0;
        0.0 0.0 0.0 4.5 1.0 2.5]
    # m = triangulize(randn(Float64, 100, 101))
    printmatrix(inverse_gaussian_step(m), " ")
    println()

    # 2
    # m = randn(Float64, 100, 101)
    m = [1.0 2.0 7.5 6.5 9.0 1.5;
        0.0 3.0 2.5 0.5 7.0 3.5;
        0.0 0.0 5.5 3.5 1.0 4.0;
        0.0 0.0 0.0 4.5 1.0 2.5]
    printmatrix(upper_triangular_gaussian(m), " ")
    println()

    # 3,4
    m = randn(Float64, 1000, 1001)
    @time(res = gaussian_solve(m))
    println(res[1, end])
    @time(res = gaussian_elimination(m))
    println(res[1, end])
    println()

    # 5
    m = randn(Float64, 100, 200)
    println(rank(m))
    println(LinearAlgebra.rank(m))
    println()

    # 6
    m = randn(Float64, 100, 100)
    println(determinant(m))
    println(det(m))
    println()
end

function triangulize(matrix::Matrix{T})::Matrix{T} where {T}
    for i in 1:size(matrix, 1)
        for j in 1:size(matrix, 2)
            if i > j 
                matrix[i, j] = zero(T)
            end
        end
    end
    return matrix
end

function printmatrix(matrix::Matrix, sep::String = "")
    for i in 1:size(matrix, 1)
        for j in 1:size(matrix, 2)
            print("$(matrix[i, j])$sep")
        end
        print("\n")
    end
end

main()

include("lib.jl")

function main()
    # 1
    p = Polynomial{Residue{Int64,7}}(
        map(x -> Residue{Int64,7}(x), [1, 2, 3, 4, 5]))
    q = Polynomial{Residue{Int64,7}}(map(x -> Residue{Int64,7}(x), [1, 2]))
    # r = p * q
    # println(r)
    println()

    # 2
    # r = Residue{Polynomial{Residue{Int64,7}},coeff_tuple(q)}(p)
    # println(r)
    println()

    # 3
    p = Polynomial{Residue{Int64,11}}(map(x -> Residue{Int64,11}(x), [1, 2, 3, 4, 5]))
    q = Polynomial{Residue{Int64,11}}(map(x -> Residue{Int64,11}(x), [1, 3]))

    # (
    #     Polynomial{Residue{Int64,11}}(Residue{Int64,11}[Residue{Int64,11}(9)]),
    #     Polynomial{Residue{Int64,11}}(Residue{Int64,11}[Residue{Int64,11}(1)]),
    #     Polynomial{Residue{Int64,11}}(Residue{Int64,11}[
    #         Residue{Int64,11}(8),
    #         Residue{Int64,11}(7),
    #         Residue{Int64,11}(9),
    #         Residue{Int64,11}(2)
    #     ])
    # )
    println(gcdx_(p, q))
    println(gcdx_(26, 15))
    println(gcdx_(35, 14))
    println()

    #4 
    println(invmod(Residue{Int64,7}(3)))
    println()

    # 5
    println(diaphant_solve(46, 30, 2))
    println(diaphant_solve(47, 30, 2))
    println()

    # 6
    println("$(isprime(3)) $(isprime(12)) $(isprime(6696)) $(isprime(743))")
    println()

    # 7
    println(eratosthenes_sieve(100))
    println()

    # 8
    println(factorize(6696))
    println()
end

main()
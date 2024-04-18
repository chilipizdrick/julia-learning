include("lib.jl")

function main()
    # 1
    p = Polynomial{Residue{Int64,7}}(
        map(x -> Residue{Int64,7}(x), [1, 2, 3, 4, 5]))
    q = Polynomial{Residue{Int64,7}}(map(x -> Residue{Int64,7}(x), [1, 2]))
    r = p * q
    println(r)
    println()

    # 2
    r = Residue{Polynomial{Residue{Int64,7}},coeff_tuple(q)}(p)
    println(r)
    println()

    # 3
    println(gcdx_(26, 15))
    println()

    #4 
    println(invmod(Residue{Int64,7}(3)))
    println()

    # 5
    println(diaphant_solve(46, 30, 2))
    println()

    # 6
    println("$(isprime(3)) $(isprime(12)) $(isprime(6696)) $(isprime(743))")
    println()

    # 7
    println(eratosthenes_sieve(100))
    println()

    # 8
    println(factorize(100))
    println()
end

main()
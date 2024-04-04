using Plots

include("./newton.jl")
include("./root.jl")
include("./jacobian.jl")
include("./log.jl")
include("./tailor.jl")

function main()
    # 1, 2
    println(newton(x -> cos(x) - x, 1.0)) # Same as newton_dual()
    println(newton_analitical(x -> cos(x) - x, x -> -sin(x) - 1, 1.0))
    println(newton_dual(x -> cos(x) - x, 1.0))
    println(newton_approx(x -> cos(x) - x, 1.0))
    println()

    # 3
    p = Polynomial{Complex{Float64}}([-1.0 + 0.0im, -3.0 + 0.0im, 2.0 + 0.0im, 1.0 + 0.0im])
    println(root(p, -2.0 + 0.0im, 0.001))
    println()

    # 4
    system = Vector{Function}([(x, y) -> x^2.0 + y^2.0 - 2.0, (x, y) -> x^3.0 * y - 1.0])
    input = ones(Float64, 2, 1)
    input[1, 1] = 2.0
    input[2, 1] = 0.0

    m = jacobian_matrix(system, [2.0, 3.0])
    println("Jacobian matrix: ", m)

    println("Solution: ", newton_compound(
        args -> -(jacobian_matrix(system, args))\calc_system(system, args),
        input))
    println()

    # 5
    println(my_log(10.0, 3.0, 0.0001))
    println(my_log_improved(10.0, 1 / 3, 0.0001))
    println()

    # 6
    println(tailor_cos(4.0, 10))
    println()

    # 7
    println(tailor_cos_to_eps(4.0))
    println(cos(4.0))
    println("Совпадение во всех цифрах, кроме последней")
    println()

    # 8
    println(tailor_e_to_eps(100.0))
    println(exp(100.0))
    println("Совпадение во всех цифрах, кроме последней")
    println(tailor_e_to_eps(-100.0))
    println(exp(-100.0))
    println("Вообще не совпадает")
    println()

    # 9
    println(tailor_bessel(3.0, 0))

    xx = -5:0.01:5
    yy = (x -> tailor_bessel(x, 0)).(xx)
    p = plot(xx, yy)
    yy = (x -> tailor_bessel(x, 1)).(xx)
    plot!(p, xx, yy)
    yy = (x -> tailor_bessel(x, 2)).(xx)
    plot!(p, xx, yy)
    display(p)

    println()

    # 10
    println(newton(x -> tailor_bessel(x, 0), 1.0))
    println()
end

main()
include("lib.jl")

using Plots

function main()
    # 1, 2
    println("Solve cos(x) = x with newton")
    println(newton(x -> cos(x) - x, 1.0)) # Same as newton_dual()
    println(newton_analitical(x -> cos(x) - x, x -> -sin(x) - 1, 1.0))
    println(newton_dual(x -> cos(x) - x, 1.0))
    println(newton_approx(x -> cos(x) - x, 1.0))
    println()

    # 3
    println("Polynomial root")
    p = Polynomial{Complex{Float64}}([-1.0 + 0.0im, -3.0 + 0.0im, 2.0 + 0.0im, 1.0 + 0.0im])
    println(root(p, -2.0 + 0.0im, 0.001))
    println()

    # 4
    println("System solution")
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
    println("Logarithm")
    println(my_log(10.0, 3.0, 0.0001))
    println(my_log_improved(10.0, 1 / 3, 0.0001))
    println()

    # 6
    println("Tailor cosign")
    println(tailor_cos(4.0, 10))
    println()

    # 7
    println("Tailor cosign to machine epsilon")
    println(tailor_cos_to_eps(4.0))
    println(cos(4.0))
    println("Совпадение во всех цифрах, кроме последней")
    println()

    # 8
    println("Tailor exponent to machine epsilon")
    println(tailor_e_to_eps(100.0))
    println(exp(100.0))
    println("Совпадение во всех цифрах, кроме последней")
    println(tailor_e_to_eps(-100.0))
    println(exp(-100.0))
    println("Вообще не совпадает")
    println()

    # 9
    println("Bessel functions")
    println(tailor_bessel(3.0, 0))

    xx = -10:0.01:10
    yy = (x -> tailor_bessel(x, 0)).(xx)
    p = plot(xx, yy)
    yy = (x -> tailor_bessel(x, 1)).(xx)
    plot!(p, xx, yy)
    yy = (x -> tailor_bessel(x, 2)).(xx)
    plot!(p, xx, yy)
    display(p)

    println()

    # 10
    println("Solve J_0(x) = 0")
    println(newton(x -> tailor_bessel(x, 0), 1.0, 1e-8, 10))
    println()
end

main()
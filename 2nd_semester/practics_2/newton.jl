include("./../dual/dual.jl")
include("./../polynomial/polynomial.jl")

function newton_analitical(f::Function, df::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Integer=10)::T where {T}
    curr_x = x
    for _ in 1:num_iterations
        val, diff = f(curr_x), df(curr_x)
        curr_x -= val / diff
        if abs(f(curr_x)) < eps
            return curr_x
        end
    end
    if abs(f(x)) > eps
        @warn("required accuracy was not reached")
    end
    return curr_x
end

function newton_compound(fdf::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Integer=10)::T where {T}
    curr_x = x
    for _ in 1:num_iterations
        curr_x += fdf(curr_x)
        # if abs(fdf(curr_x)) < eps
        #     return curr_x
        # end
    end
    return curr_x
end

function newton_dual(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Integer=10)::T where {T}
    return newton_analitical(f, x -> valdiff(f, x)[2], x, eps, num_iterations)
end

# newton(...) is alias for newton_dual(...)
function newton(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Integer=10)::T where {T}
    return newton_dual(f, x, eps, num_iterations)
end

function newton_approx(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Integer=10)::T where {T}
    return newton_analitical(f, x -> (f(x + T(1e-8)) - f(x)) / (T(1e-8)), x, eps, num_iterations)
end

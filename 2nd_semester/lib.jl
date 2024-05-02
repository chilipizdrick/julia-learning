using Base

# --- Polynomial ---

abstract type AbstractPolynomial <: Number end

struct Polynomial{T} <: AbstractPolynomial
    coeffs::Vector{T}

    function Polynomial{T}() where {T}
        return new{T}(Vector{T}([Base.zero(T)]))
    end

    function Polynomial{T}(::Type{T}) where {T}
        return new{T}(Vector{T}([Base.zero(T)]))
    end

    function Polynomial{T}(a::T) where {T}
        return new{T}(Vector{T}([a]))
    end

    function Polynomial{T}(coeff::Vector{T}) where {T}
        if length(coeff) < 1
            return new{T}(Vector{T}([Base.zero(T)]))
        end

        index = findlast(x -> !Base.iszero(x), coeff)
        if isnothing(index)
            return new{T}(Vector{T}([Base.zero(T)]))
        end

        return new{T}(coeff[begin:index])
    end

    function Polynomial{T}(coeff::Tuple) where {T}
        if length(coeff) < 1
            return new{T}(Vector{T}([Base.zero(T)]))
        end

        index = findlast(x -> !Base.iszero(x), coeff)
        if isnothing(index)
            return new{T}(Vector{T}([Base.zero(T)]))
        end

        return new{T}(Vector{T}([coeff[begin:index]...]))
    end
end

function coeff_tuple(p::Polynomial{T})::NTuple{length(p.coeffs),T} where {T}
    return Tuple(p.coeffs)
end

function copy(p::Polynomial{T})::Polynomial{T} where {T}
    r = Base.copy(p.coeffs)
    return Polynomial{T}(r)
end

function Base.zero(_::Polynomial{T})::Polynomial{T} where {T}
    return Polynomial{T}(Base.zero(T))
end
function Base.zero(::Type{Polynomial{T}})::Polynomial{T} where {T}
    return Polynomial{T}(Base.zero(T))
end

function Base.one(_::Polynomial{T})::Polynomial{T} where {T}
    return Polynomial{T}(Base.one(T))
end
function Base.one(::Type{Polynomial{T}})::Polynomial{T} where {T}
    return Polynomial{T}(Base.one(T))
end

function Base.:(==)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return false
    end
    for i in 1:length(p.coeffs)
        if p.coeffs[i] != q.coeffs[i]
            return false
        end
    end
    return true
end

function Base.:(!=)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return true
    end
    for i in 1:length(p.coeffs)
        if p.coeffs[i] != q.coeffs[i]
            return true
        end
    end
    return false
end

function Base.:(>)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return length(p.coeffs) > length(q.coeffs) ? true : false
    end
    for i in length(p.coeffs):1
        if p.coeffs[i] <= p.coeffs[i]
            return false
        end
    end
    return true
end

function Base.:(<)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return length(p.coeffs) < length(q.coeffs) ? true : false
    end
    for i in length(p.coeffs):1
        if p.coeffs[i] >= p.coeffs[i]
            return false
        end
    end
    return true
end

function Base.:(>=)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return length(p.coeffs) > length(q.coeffs) ? true : false
    end
    for i in length(p.coeffs):1
        if p.coeffs[i] < p.coeffs[i]
            return false
        end
    end
    return true
end

function Base.:(<=)(p::Polynomial{T}, q::Polynomial{T})::Bool where {T}
    if length(p.coeffs) != length(q.coeffs)
        return length(p.coeffs) < length(q.coeffs) ? true : false
    end
    for i in length(p.coeffs):1
        if p.coeffs[i] > p.coeffs[i]
            return false
        end
    end
    return true
end

function lead(p::Polynomial{T})::T where {T}
    return last(p.coeffs)
end

function ord(p::Polynomial{T})::Int64 where {T}
    return length(p.coeffs) - 1
end

function Base.:(-)(p::Polynomial{T})::Polynomial{T} where {T}
    Polynomial{T}(map(x -> -x, p.coeffs))
end

function Base.:(+)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    m = length(p.coeffs)
    n = length(q.coeffs)

    if m > n
        r = copy(p)
        r.coeffs[begin:n] .+= q.coeffs
    else
        r = copy(q)
        r.coeffs[begin:m] .+= p.coeffs
    end

    return Polynomial{T}(r.coeffs)
end

function Base.:(+)(p::Polynomial{T}, a::T)::Polynomial{T} where {T}
    return p + Polynomial{T}([a])
end

function Base.:(+)(a::T, p::Polynomial{T})::Polynomial{T} where {T}
    return p + Polynomial{T}([a])
end

function Base.:(-)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    m = length(p.coeffs)
    n = length(q.coeffs)

    if m >= n
        r = copy(p)
        r.coeffs[begin:n] .-= q.coeffs
        return Polynomial{T}(r.coeffs)
    else
        r_coeffs = Base.copy(p.coeffs)
        for _ in (length(p.coeffs)+1):length(q.coeffs)
            push!(r_coeffs, Base.zero(T))
        end
        r_coeffs .-= q.coeffs
        return Polynomial{T}(r_coeffs)
    end
end

function Base.:(-)(p::Polynomial{T}, a::T)::Polynomial{T} where {T}
    return p - Polynomial{T}([a])
end

function Base.:(-)(a::T, p::Polynomial{T})::Polynomial{T} where {T}
    return Polynomial{T}([a]) - p
end

function Base.:(*)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    r = Polynomial{T}(Vector{T}())
    for i in eachindex(p.coeffs)
        temp_coeffs = Vector{T}()
        for _ in 1:(i-1)
            append!(temp_coeffs, [Base.zero(T)])
        end
        for j in eachindex(q.coeffs)
            append!(temp_coeffs, [p.coeffs[i] * q.coeffs[j]])
        end
        r = r + Polynomial{T}(temp_coeffs)
    end
    return r
end

function Base.:(*)(p::Polynomial{T}, a::T)::Polynomial{T} where {T}
    return Polynomial{T}(p.coeffs .* a)
end

function Base.:(*)(a::T, p::Polynomial{T})::Polynomial{T} where {T}
    return Polynomial{T}(p.coeffs .* a)
end

function Base.divrem(p::Polynomial{T}, q::Polynomial{T})::Tuple{Polynomial{T},Polynomial{T}} where {T}
    if q == Polynomial{T}()
        throw(ErrorException("polynomial division by 0-polynomial"))
    end

    quotent = Polynomial{T}()
    remainder = copy(p)

    while remainder != Polynomial{T}() && ord(remainder) >= ord(q)
        coeffs = Vector{T}()
        power = ord(remainder) - ord(q)
        for _ in 1:power
            push!(coeffs, Base.zero(T))
        end
        push!(coeffs, lead(remainder) / lead(q))
        t = Polynomial{T}(coeffs)

        quotent = quotent + t
        remainder = remainder - t * q
    end

    return (quotent, remainder)
end

function Base.:(/)(p::Polynomial{T}, q::Polynomial{T})::Tuple{Polynomial{T},Polynomial{T}} where {T}
    return Base.divrem(p, q)
end

function Base.div(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[1]
end

function Base.:(÷)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[1]
end

function Base.:(%)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[2]
end

function Base.mod(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[2]
end

function Base.mod(p::Polynomial{T}, q::Tuple)::Polynomial{T} where {T}
    return mod(p, Polynomial{T}(q))
end

function (p::Polynomial{T})(x) where {T}
    if length(p.coeffs) == 1
        return p.coeffs[1]
    end

    res = 0
    for i in lastindex(p.coeffs):-1:1
        res = res * x + p.coeffs[i]
    end

    return res
end

function valdiff(p::Polynomial{T}, x::T) where {T}
    res, diffres = Base.zero(T), Base.zero(T)
    for i in lastindex(p.coeffs):-1:2
        res = res * x + p.coeffs[i]
        diffres = diffres * x + (i - 1) * p.coeffs[i]
    end
    res = res * x + p.coeffs[1]

    return (res, diffres)
end

# function differentiate(p::Polynomial{T})::Polynomial{T} where {T}
#     if ord(p) < 1
#         return Polynomial{T}(Base.zero(T))
#     end

#     coeffs = Vector{T}()
#     for i in 2:length(p.coeffs)
#         append!(coeffs, (i - 1) * p.coeffs[i])
#     end

#     return Polynomial{T}(coeffs)
# end

# function derivative(p::Polynomial{T}, arg::T)::T where {T}
#     dp = differentiate(p)
#     return value(dp, arg)
# end

function Base.display(p::Polynomial{T})::String where {T}
    res = ""
    for i in reverse(eachindex(p.coeffs))
        if p.coeffs[i] != Base.zero(T)
            if i == length(p.coeffs)
                res *= "$(p.coeffs[i])x^$(i-1)"
            elseif i == 2
                res *= " + $(p.coeffs[i])x"
            elseif i == 1
                res *= " + $(p.coeffs[i])"
            else
                res *= " + $(p.coeffs[i])x^$(i-1)"
            end
        end
    end
    println(res)
    return res
end

# --- Dual ---

struct Dual{T} <: Number
    a::T
    b::T

    function Dual{T}(a::T, b::T)::Dual{T} where {T}
        return new{T}(a, b)
    end

    function Dual{T}(a::T)::Dual{T} where {T}
        return new{T}(a, Base.one(T))
    end

    function Dual{T}()::Dual{T} where {T}
        return new{T}(Base.one(T), Base.one(T))
    end
end

Base.real(x::Dual{T}) where {T<:Number} = x.a
Base.imag(x::Dual{T}) where {T<:Number} = x.b
Base.zero(::Type{Dual{T}}) where {T<:Number} = Dual{T}(Base.zero(T), Base.one(T))
Base.one(::Type{Dual{T}}) where {T<:Number} = Dual{T}(Base.one(T), Base.one(T))
Base.eps(::Type{Dual{T}}) where {T<:Number} = Dual{T}(Base.eps(T), Base.one(T))
Base.copy(d::Dual{T}) where {T<:Number} = Dual{T}(d.a, d.b)
Base.conj(d::Dual{T}) where {T<:Number} = Dual{T}(d.a, -d.b)

Base.:(==)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a == d2.a && d.b == d2.b
Base.:(!=)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a != d2.a || d.b != d2.b
Base.:(>)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a > d2.a
Base.:(<)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a < d2.a
Base.:(>=)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a >= d2.a
Base.:(<=)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = d.a <= d2.a


Base.:(-)(d::Dual{T}) where {T<:Number} = Dual{T}(-d.a, -d.b)

Base.:(+)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = Dual{T}(d.a + d2.a, d.b + d2.b)
Base.:(+)(d::Dual{T}, n::T) where {T<:Number} = Dual{T}(d.a + n, d.b)
Base.:(+)(n::T, d::Dual{T}) where {T<:Number} = Dual{T}(n + d.a, d.b)

Base.:(-)(d::Dual{T}, d2::Dual{T}) where {T<:Number} = Dual{T}(d.a - d2.a, d.b - d2.b)
Base.:(-)(d::Dual{T}, n::T) where {T<:Number} = Dual{T}(d.a - n, d.b)
Base.:(-)(n::T, d::Dual{T}) where {T<:Number} = Dual{T}(n - d.a, d.b)

Base.:*(x::Dual{T}, y::Dual{T}) where {T<:Number} = Dual{T}(x.a * y.a, x.a * y.b + x.b * y.a)
Base.:*(x::Dual{T}, y::T) where {T<:Number} = Dual{T}(x.a * y, x.b * y)
Base.:*(x::T, y::Dual{T}) where {T<:Number} = Dual{T}(x * y.a, x * y.b)

Base.:/(x::Dual{T}, y::Dual{T}) where {T<:Number} = Dual{T}(x.a / y.a, (x.b * y.a - x.a * y.b) / (y.a * y.a))
Base.:/(x::Dual{T}, y::T) where {T<:Number} = Dual{T}(x.a / y, x.b / y)
Base.:/(x::T, y::Dual{T}) where {T<:Number} = Dual{T}(x / y.a, -x * y.b / (y.a * y.a))

Base.:^(x::Dual{T}, y::Integer) where {T<:Number} = Dual{T}(x.a^y, y * x.a^(y - 1) * x.b)
Base.:^(x::Dual{T}, y::Dual{T}) where {T<:Number} = Dual{T}(x.a^y.a, (y.a * x.b * x.a^(y.a - 1) + x.a^y.a * log(x.a) * y.b))
Base.:^(x::Dual{T}, y::T) where {T<:Number} = Dual{T}(x.a^y, y * x.a^(y - 1) * x.b)
Base.:^(x::T, y::Dual{T}) where {T<:Number} = Dual{T}(x^y.a, y * x^(y.a - 1) * x.b)

Base.sqrt(x::Dual{T}) where {T<:Number} = Dual{T}(sqrt(x.a), x.b / (2 * sqrt(x.a)))

Base.cos(x::Dual{T}) where {T<:Number} = Dual{T}(cos(x.a), -x.b * sin(x.a))
Base.tan(x::Dual{T}) where {T<:Number} = Dual{T}(tan(x.a), (1 + tan(x.a)^2) * x.b)
Base.atan(x::Dual{T}) where {T<:Number} = Dual{T}(atan(x.a), x.b / (1 + x.a^2))
Base.asin(x::Dual{T}) where {T<:Number} = Dual{T}(asin(x.a), x.b / (sqrt(1 - x.a^2)))
Base.acos(x::Dual{T}) where {T<:Number} = Dual{T}(acos(x.a), -x.b / (sqrt(1 - x.a^2)))

Base.sinh(x::Dual{T}) where {T<:Number} = Dual{T}(sinh(x.a), x.b * cosh(x.a))
Base.cosh(x::Dual{T}) where {T<:Number} = Dual{T}(cosh(x.a), x.b * sinh(x.a))
Base.tanh(x::Dual{T}) where {T<:Number} = Dual{T}(tanh(x.a), (1 - tanh(x.a)^2) * x.b)
Base.asinh(x::Dual{T}) where {T<:Number} = Dual{T}(asinh(x.a), x.b / (sqrt(1 + x.a^2)))
Base.acosh(x::Dual{T}) where {T<:Number} = Dual{T}(acosh(x.a), x.b / (sqrt(x.a^2 - 1)))
Base.atanh(x::Dual{T}) where {T<:Number} = Dual{T}(atanh(x.a), x.b / (1 - x.a^2))

Base.exp(x::Dual{T}) where {T<:Number} = Dual{T}(exp(x.a), x.b * exp(x.a))
Base.log(x::Dual{T}) where {T<:Number} = Dual{T}(log(x.a), x.b / (x.a * log(x.a)))
Base.log2(x::Dual{T}) where {T<:Number} = Dual{T}(log2(x.a), x.b / (x.a * log2(x.a)))
Base.log10(x::Dual{T}) where {T<:Number} = Dual{T}(log10(x.a), x.b / (x.a * log10(x.a)))
Base.log(a::Number, ::Dual{T}) where {T<:Number} = Dual{T}(log(a, x.a), x.b / (x.a * log(a, x.a)))

Base.abs(x::Dual{T}) where {T<:Number} = Dual{T}(abs(x.a), sign(x.a) * x.b)

function valdiff(f::Function, x::T)::Tuple where {T<:Number}
    z = f(Dual{T}(x))
    return real(z), imag(z)
end

function Base.display(d::Dual{T}) where {T<:Number}
    res = "$(d.a) + $(d.b)ε"
    println(res)
    return res
end

function valdiff(p::Polynomial{T}, x::T, ::Type{Dual})::Tuple{T,T} where {T<:Number}
    z = p(Dual{T}(x))
    return real(z), imag(z)
end

# --- Residue ---

struct Residue{T,M}
    value::T

    function Residue{T,M}(value::T) where {T,M}
        return new(Base.mod(value, M))
    end
end

ringmod(::Residue{T,M}) where {T,M} = M
value(a::Residue{T,M}) where {T,M} = a.value
Base.zero(::Type{Residue{T,M}}) where {T,M} = Residue{T,M}(Base.zero(T))
Base.zero(::Residue{T,M}) where {T,M} = Residue{T,M}(Base.zero(T))
Base.one(::Type{Residue{T,M}}) where {T,M} = Residue{T,M}(Base.one(T))
Base.one(::Residue{T,M}) where {T,M} = Residue{T,M}(Base.one(T))
Base.eps(::Type{Residue{T,M}}) where {T,M} = Residue{T,M}(Base.eps(T))
Base.eps(::Residue{T,M}) where {T,M} = Residue{T,M}(Base.eps(T))

Base.:(==)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value == b.value
Base.:(!=)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value != b.value
Base.:(<)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value < b.value
Base.:(>)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value > b.value
Base.:(<=)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value <= b.value
Base.:(>=)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a.value >= b.value

Base.:(+)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value + b.value)
Base.:(-)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value - b.value)
Base.:(-)(a::Residue{T,M}) where {T,M} = Residue{T,M}(-a.value)
Base.:(*)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value * b.value)
Base.:(^)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = Residue{T,M}(a.value^b.value)

function Base.invmod(a::Residue{T,M})::Union{Residue{T,M},Nothing} where {T,M}
    gcd, inverse, _ = gcdx_(a.value, M)
    if gcd != one(a.value)
        return nothing
    end
    return Residue{T,M}(mod(inverse, M))
end

Base.:(/)(a::Residue{T,M}, b::Residue{T,M}) where {T,M} = a * invmod(b)

function Base.display(r::Residue{T,M}) where {T,M}
    println("$(r.value) (mod $M)")
end

# --- Newton ---

function newton_analitical(f::Function, df::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Int64=10)::T where {T}
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

function newton_compound(fdf::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Int64=10)::T where {T}
    curr_x = x
    for _ in 1:num_iterations
        curr_x += fdf(curr_x)
        # if abs(fdf(curr_x)) < eps
        #     return curr_x
        # end
    end
    return curr_x
end

function newton_dual(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Int64=10)::T where {T}
    return newton_analitical(f, x -> valdiff(f, x)[2], x, eps, num_iterations)
end

# newton(...) is alias for newton_dual(...)
function newton(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Int64=10)::T where {T}
    return newton_dual(f, x, eps, num_iterations)
end

function newton_approx(f::Function, x::T, eps::AbstractFloat=1e-8, num_iterations::Int64=10)::T where {T}
    return newton_analitical(f, x -> (f(x + T(1e-8)) - f(x)) / (T(1e-8)), x, eps, num_iterations)
end

# --- Jacobian ---

function jacobian_matrix(system::Vector{Function}, argument_vector::Vector{T})::Matrix{T} where {T}
    @assert(length(system) == length(argument_vector))

    n = length(system)
    res = zeros(T, n, n)

    for i in 1:n
        func = system[i]
        for j in 1:n
            arguments = Vector{Union{Dual{T},T}}(argument_vector)
            arguments[j] = Dual{T}(arguments[j])
            part_der = imag(func(arguments...))
            res[i, j] = part_der
        end
    end

    return res
end

function jacobian_matrix(system::Vector{Function}, argument_vector::Matrix{T})::Matrix{T} where {T}
    @assert(length(system) == length(argument_vector))

    n = length(system)
    res = zeros(T, n, n)

    for i in 1:n
        func = system[i]
        for j in 1:n
            arguments = Matrix{Union{Dual{T},T}}(argument_vector)
            arguments[j, 1] = Dual{T}(arguments[j])
            part_der = imag(func(arguments...))
            res[i, j] = part_der
        end
    end

    return res
end

function calc_system(system::Vector{Function}, args::Matrix{T})::Matrix{T} where {T}
    res = zeros(T, length(system), 1)
    for i in eachindex(system)
        res[i] = system[i](args...)
    end
    return res
end

# --- Log ---

function my_log(x::T, base::T=2, eps::AbstractFloat=1e-8)::T where {T} # base > 1
    @assert(base > 1)
    @assert(x > 0)
    z = x
    t = Base.one(T)
    y = Base.zero(T)
    while z < 1 / base || z > base || t > eps
        if z < 1 / base
            z *= base
            y -= t
        elseif z > base
            z /= base
            y += t
        elseif t > eps
            t /= 2
            z *= z
        end
    end
    return y
end

function my_log_improved(x::T, base::T=2, eps::AbstractFloat=1e-8)::T where {T}
    @assert(base > 1 || base < 1)
    @assert(x > 0)

    if base > 1
        return my_log(x, base, eps)
    else
        return -my_log(x, 1 / base, eps)
    end
end

# --- Root ---

function root(p::Polynomial{Complex{T}}, x0::Complex{T}, eps::AbstractFloat=1e-8)::Union{Complex{T},Nothing} where {T}
    res = newton_analitical(x -> p(x), x -> valdiff(p, x)[2], x0, eps)
    if abs(p(res)) > eps
        return nothing
    end
    return res
end

# --- Tailor series ---

function tailor_cos(x::T, n::Int64)::T where {T}
    res = Base.zero(T)
    ak = Base.one(T)
    for k in 1:n
        coeff = -(x * x) / (2 * k * (2 * k - 1))
        ak = ak * coeff
        res += ak
    end
    return res
end

function tailor_cos_to_eps(x::T)::T where {T}
    res = Base.zero(T)
    ak = Base.one(T)
    k = 1
    while abs(ak) > Base.eps(typeof(x))
        res += ak
        coeff = -(x * x) / (2 * k * (2 * k - 1))
        ak = ak * coeff
        k += 1
    end
    return res
end

function tailor_e_to_eps(x::T)::T where {T}
    res = Base.zero(T)
    ak = Base.one(T)
    k = 1
    while abs(ak) > Base.eps(typeof(x))
        res += ak
        coeff = x / k
        ak = ak * coeff
        k += 1
    end
    return res
end

function tailor_bessel(x::T, a::Int64=0)::T where {T}
    res = Base.zero(T)
    ak = (x / 2.0)^a / float(factorial(a))
    k = 1
    while abs(ak) > eps(T)
        res += ak
        coeff = -(x * x) / convert(4 * k * (k + a), T)
        ak = ak * coeff
        k += 1
    end
    return res
end

# --- gcdx_ ---

function gcdx_(a::T, b::T)::Tuple{T,T,T} where {T}
    u, v = one(T), zero(T)
    u_, v_ = v, u

    while !iszero(b)
        k, r = divrem(a, b)
        a, b = b, r
        u, u_ = u_, u - k * u_
        v, v_ = v_, v - k * v_
    end
    if a < zero(T)
        a, u, v = -a, -u, -v
    end
    return a, u, v
end

function diaphant_solve(a::T, b::T, c::T)::Union{Tuple{T,T},Nothing} where {T}
    if mod(a, c) != 0 || mod(b, c) != 0
        return nothing
    end
    a /= c
    b /= c
    _, x, y = gcdx_(a, b)
    return x, y
end

# --- Primes and factorization ---

function isprime(num::T)::Bool where {T}
    for div in 2:floor(sqrt(num))
        if mod(num, div) == 0
            return false
        end
    end
    return true
end

function eratosthenes_sieve(n::T)::Vector{T} where {T<:Integer}
    seive = ones(Bool, n)
    seive[1] = false
    for i in 2:T(floor((sqrt(n))))
        if seive[i]
            for j in (i*i):i:n
                seive[j] = false
            end
        end
    end
    return filter(x -> seive[x], 1:n)
end

function factorize(n::T)::Vector{NamedTuple} where {T<:Integer}
    res = NamedTuple{(:div, :deg),Tuple{T,T}}[]
    for p in eratosthenes_sieve(T(ceil(n / 2)))
        k = degree(n, p)
        if k > 0
            push!(res, (div=p, deg=k))
        end
    end
    return res
end

function degree(n::T, d::T)::T where {T<:Integer}
    i = zero(T)
    while mod(n, d) == 0
        n /= d
        i += 1
    end
    return i
end

# --- Inverse Gaussian matrix transform ---

function inverse_gaussian_step(matrix::Matrix{T})::Matrix{T} where {T<:Number}
    m, _ = size(matrix)
    coeff = matrix[m, m]
    matrix[m, :] ./= coeff
    current_row = m
    for _ in m:-1:2
        for k in current_row:-1:1
            if k != current_row
                matrix[k, :] .-= (@view(matrix[current_row, :]) .*
                                  matrix[k, current_row])
            end
        end
        current_row -= 1
        coeff = matrix[current_row, current_row]
        matrix[current_row, :] ./= coeff
    end
    return matrix
end

function upper_triangular_gaussian(matrix::Matrix{T})::Matrix{T} where {T<:Number}
    m, _ = size(matrix)
    coeff = matrix[1, 1]
    matrix[1, :] ./= coeff
    current_row = 1
    for _ in 1:m-1
        for k in current_row:m
            if k != current_row
                matrix[k, :] .-= (@view(matrix[current_row, :]) .*
                                  matrix[k, current_row])
            end
        end
        current_row += 1
        coeff = matrix[current_row, current_row]
        matrix[current_row, :] ./= coeff
    end
    return matrix
end

# Unoptimized gaussian elimination
function gaussian_solve(matrix::Matrix{T})::Matrix{T} where {T}
    return inverse_gaussian_step(upper_triangular_gaussian(matrix))
end

function determinant(matrix::Matrix{T})::T where {T}
    determinant = 1

    m, n = size(matrix)
    @assert(m == n)

    m, _ = size(matrix)
    for i in axes(matrix, 1)
        if matrix[i, i] == 0.0
            swap_rows(i, m)
        end
        @view(matrix[i, :]) ./= matrix[i, i]
        determinant *= matrix[i, i]
        for j in axes(matrix, 1)
            if j != i
                @view(matrix[j, :]) .-= matrix[i, :] .* matrix[j, i]
            end
        end
    end

    return determinant
end

function rank(matrix::Matrix{T})::Int64 where {T}
    ctn = 0
    matrix = gaussian_elimination(matrix)
    _, n = size(matrix)
    for i in axes(matrix, 1)
        if any(matrix[i, :] != 0)
            ctn += 1
        end
    end
    return ctn
end

# Optimized gaussian elimination
function gaussian_elimination(A::Matrix{T})::Matrix{T} where {T<:Number}
    m, _ = size(A)
    for i in axes(A, 1)
        if A[i, i] == 0.0
            swap_rows(i, m)
        end
        @view(A[i, :]) ./= A[i, i]
        for j in axes(A, 1)
            if j != i
                @view(A[j, :]) .-= A[i, :] .* A[j, i]
            end
        end
    end
    return A
end

function swap_rows(i::T, m::T) where {T<:Integer}
    for n in (i+1):m
        if A[n, i] != 0.0
            A[i, :], A[n, :] = A[i, :], A[n, :]
        end
    end
end
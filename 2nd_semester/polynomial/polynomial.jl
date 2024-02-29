abstract type AbstractPolynomial <: Number end

struct Polynomial{T} <: AbstractPolynomial
    coeffs::Vector{T}

    function Polynomial{T}() where {T}
        return new{T}(Vector{T}([zero(T)]))
    end

    function Polynomial{T}(coeff::Vector{T}) where {T}
        if length(coeff) < 1
            return new{T}(Vector{T}([zero(T)]))
        end

        index = findlast(x -> !iszero(x), coeff)
        if isnothing(index)
            return new{T}(Vector{T}([zero(T)]))
        end

        return new{T}(coeff[begin:index])
    end
end

function copy(p::Polynomial{T})::Polynomial{T} where {T}
    r = Base.copy(p.coeffs)
    return Polynomial{T}(r)
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

function lead(p::Polynomial{T})::T where {T}
    return last(p.coeffs)
end

function ord(p::Polynomial{T})::Integer where {T}
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
            append!(r_coeffs, zero(T))
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
            append!(temp_coeffs, zero(T))
        end
        for j in eachindex(q.coeffs)
            append!(temp_coeffs, p.coeffs[i] * q.coeffs[j])
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
            append!(coeffs, zero(T))
        end
        append!(coeffs, lead(remainder) / lead(q))
        t = Polynomial{T}(coeffs)

        quotent = quotent + t
        remainder = remainder - t * q
    end

    return (quotent, remainder)
end

function Base.:(/)(p::Polynomial{T}, q::Polynomial{T})::Tuple{Polynomial{T},Polynomial{T}} where {T}
    return Base.divrem(p, q)
end

function Base.:(//)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[1]
end

function Base.:(÷)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[1]
end

function Base.:(%)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    return (divrem(p, q))[2]
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
    res, diffres = zero(T), zero(T)
    for i in lastindex(p.coeffs):-1:2
        res = res*x + p.coeffs[i]
        diffres = diffres*x + (i-1)*p.coeffs[i]
    end
    res = res*x + p.coeffs[1]

    return (res, diffres)
end

# function differentiate(p::Polynomial{T})::Polynomial{T} where {T}
#     if ord(p) < 1
#         return Polynomial{T}(zero(T))
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
        if p.coeffs[i] != zero(T)
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

struct Polynomial{T}
    coeffs::Vector{T}

    function Polynomial{T}() where {T}
        return new{T}(Vector{T}([zero(T)]))
    end

    function Polynomial{T}(coeff::Vector{T}) where {T}
        if length(coeff) < 1
            return new{T}(Vector{T}([zero(T)]))
        end

        index = lastindex(coeff)
        for i in lastindex(coeff):-1:firstindex(coeff)
            if !iszero(coeff[i])
                index = i
                break
            end
            if i == firstindex(coeff)
                return new{T}(Vector{T}([zero(T)]))
            end
        end

        return new{T}(coeff[begin:index])
    end
end

function copy(p::Polynomial{T})::Polynomial{T} where {T}
    r = Base.copy(p.coeffs)
    # println(r)
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

function Base.:(-)(p::Polynomial{T}, q::Polynomial{T})::Polynomial{T} where {T}
    m = length(p.coeffs)
    n = length(q.coeffs)

    if m > n
        r = copy(p)
        r.coeffs[begin:n] .-= q.coeffs
    else
        r = copy(q)
        r.coeffs[begin:m] .-= p.coeffs
    end

    return Polynomial{T}(r.coeffs)
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

# Fix this
function Base.:(/)(p::Polynomial{T}, q::Polynomial{T})::Tuple{Polynomial{T},Polynomial{T}} where {T}
    if q == Polynomial{T}()
        throw(ErrorException("polynomial division by 0-polynomial"))
    end

    quotent = Polynomial{T}()
    remainder = copy(p)

    while remainder != Polynomial{T}() && ord(remainder) >= ord(q)
        # Divide the leading terms (remainder / q)
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


function Base.:(//)(p::Polynomial{T}, q::Polynomial{T})::(Polynomial{T}, Polynomial{T}) where {T}
    return (p/q)[1]
end

function Base.:(%)(p::Polynomial{T}, q::Polynomial{T})::(Polynomial{T}, Polynomial{T}) where {T}
    return (p/q)[2]
end

function value(p::Polynomial{T}, arg::S)::S where {T,S}
    res = zero(S)
    for i in eachindex(p.coeffs)
        res += arg^(i - 1) * S(p.coeffs[i])
    end
    return res
end

function differentiate(p::Polynomial{T})::Polynomial{T} where {T}
    if ord(p) < 1
        return Polynomial{T}(zero(T))
    end

    coeffs = Vector{T}()
    for i in 2:length(p.coeffs)
        append!(coeffs, (i - 1) * p.coeffs[i])
    end

    return Polynomial{T}(coeffs)
end

function derivative(p::Polynomial{T}, arg::S)::S where {T,S}
    dp = differentiate(p)
    return value(dp, arg)
end

function display(p::Polynomial{T})::String where {T}
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
    return res
end

function display!(p::Polynomial{T})::String where {T}
    res = display(p)
    println(res)
    return res
end
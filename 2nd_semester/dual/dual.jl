struct Dual{T} <: Number
    a::T
    b::T

    function Dual{T}(a::T, b::T)::Dual{T} where {T}
        return new{T}(a, b)
    end

    function Dual{T}(a::T)::Dual{T} where {T}
        return new{T}(a, Base.zero(T))
    end

    function Dual{T}()::Dual{T} where {T}
        return new{T}(Base.zero(T), Base.zero(T))
    end
end


real(x::Dual{T}) where {T} = x.a
imag(x::Dual{T}) where {T} = x.b
zero(::Dual{T}) where {T} = Dual{T}(Base.zero{T}, Base.zero{T})
one(::Dual{T}) where {T} = Dual{T}(Base.one{T}, Base.zero{T})
eps(::Dual{T}) where {T} = Dual{T}(Base.zero{T}, Base.one{T})
copy(d::Dual{T}) where {T} = Dual{T}(d.a, d.b)
conj(d::Dual{T}) where {T} = Dual{T}(d.a, -d.b)

Base.:(==)(d::Dual{T}, d2::Dual{T}) where {T} = d.a == d2.a && d.b == d2.b
Base.:(!=)(d::Dual{T}, d2::Dual{T}) where {T} = d.a != d2.a || d.b != d2.b

Base.:(-)(d::Dual{T}) where {T} = Dual{T}(-d.a, -d.b)

Base.:(+)(d::Dual{T}, d2::Dual{T}) where {T} = Dual{T}(d.a + d2.a, d.b + d2.b)
Base.:(+)(d::Dual{T}, n::T) where {T} = Dual{T}(d.a + n, d.b)
Base.:(+)(n::T, d::Dual{T}) where {T} = Dual{T}(n + d.a, d.b)

Base.:(-)(d::Dual{T}, d2::Dual{T}) where {T} = Dual{T}(d.a - d2.a, d.b - d2.b)
Base.:(-)(d::Dual{T}, n::T) where {T} = Dual{T}(d.a - n, d.b)
Base.:(-)(n::T, d::Dual{T}) where {T} = Dual{T}(n - d.a, d.b)

Base.:*(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a * y.a, x.a * y.b + x.b * y.a)
Base.:*(x::Dual{T}, y::T) where {T} = Dual{T}(x.a * y, x.b * y)
Base.:*(x::T, y::Dual{T}) where {T} = Dual{T}(x * y.a, x * y.b)

Base.:/(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a / y.a, (x.b * y.a - x.a * y.b) / (y.a * y.a))
Base.:/(x::Dual{T}, y::T) where {T} = Dual{T}(x.a / y, x.b / y)
Base.:/(x::T, y::Dual{T}) where {T} = Dual{T}(x / y.a, -x * y.b / (y.a * y.a))

Base.:^(x::Dual{T}, y::Integer) where {T} = Dual{T}(x.a^y, y * x.a^(y - 1) * x.b)
Base.:^(x::Dual{T}, y::Dual{T}) where {T} = Dual{T}(x.a^y.a, (y.a * x.b * x.a^(y.a - 1) + x.a^y.a * log(x.a) * y.b))
Base.:^(x::Dual{T}, y::T) where {T} = Dual{T}(x.a^y, y * x.a^(y - 1) * x.b)
Base.:^(x::T, y::Dual{T}) where {T} = Dual{T}(x^y.a, y * x^(y.a - 1) * x.b)

Base.sqrt(x::Dual{T}) where {T} = Dual{T}(sqrt(x.a), x.b / (2 * sqrt(x.a)))

Base.cos(x::Dual{T}) where {T} = Dual{T}(cos(x.a), -x.b * sin(x.a))
Base.tan(x::Dual{T}) where {T} = Dual{T}(tan(x.a), (1 + tan(x.a)^2) * x.b)
Base.atan(x::Dual{T}) where {T} = Dual{T}(atan(x.a), x.b / (1 + x.a^2))
Base.asin(x::Dual{T}) where {T} = Dual{T}(asin(x.a), x.b / (sqrt(1 - x.a^2)))
Base.acos(x::Dual{T}) where {T} = Dual{T}(acos(x.a), -x.b / (sqrt(1 - x.a^2)))

Base.sinh(x::Dual{T}) where {T} = Dual{T}(sinh(x.a), x.b * cosh(x.a))
Base.cosh(x::Dual{T}) where {T} = Dual{T}(cosh(x.a), x.b * sinh(x.a))
Base.tanh(x::Dual{T}) where {T} = Dual{T}(tanh(x.a), (1 - tanh(x.a)^2) * x.b)
Base.asinh(x::Dual{T}) where {T} = Dual{T}(asinh(x.a), x.b / (sqrt(1 + x.a^2)))
Base.acosh(x::Dual{T}) where {T} = Dual{T}(acosh(x.a), x.b / (sqrt(x.a^2 - 1)))
Base.atanh(x::Dual{T}) where {T} = Dual{T}(atanh(x.a), x.b / (1 - x.a^2))

Base.exp(x::Dual{T}) where {T} = Dual{T}(exp(x.a), x.b * exp(x.a))
Base.log(x::Dual{T}) where {T} = Dual{T}(log(x.a), x.b / (x.a * log(x.a)))
Base.log2(x::Dual{T}) where {T} = Dual{T}(log2(x.a), x.b / (x.a * log2(x.a)))
Base.log10(x::Dual{T}) where {T} = Dual{T}(log10(x.a), x.b / (x.a * log10(x.a)))
Base.log(a::AbstractFloat, ::Dual{T}) where {T} = Dual{T}(log(a, x.a), x.b / (x.a * log(a, x.a)))

function valdiff(f::Function, x)
    return f(x), f(x)
end

function Base.display(d::Dual{T}) where {T}
    res = "$(d.a) + $(d.b)ε"
    println(res)
    return res
end

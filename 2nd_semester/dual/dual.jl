struct Dual{T}
    a::T
    b::T

    function Dual{T}(a::T, b::T) where {T}
        return new{T}(a, b)
    end
end

function copy(d::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a, d.b)
end

function Base.:(==)(d::Dual{T}, e::Dual{T})::Bool where {T}
    return d.a == e.a && d.b == e.b
end

function Base.:(!=)(d::Dual{T}, e::Dual{T})::Bool where {T}
    return d.a != e.a || d.b != e.b
end

function conj(d::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a, -d.b)
end

function Base.:(-)(d::Dual{T})::Dual{T} where {T}
    return Dual{T}(-d.a, -d.b)
end

function Base.:(+)(d::Dual{T}, e::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a + e.a, d.b + e.b)
end

function Base.:(-)(d::Dual{T}, e::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a - e.a, d.b - e.b)
end

function Base.:(*)(d::Dual{T}, e::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a * e.a, d.a * e.b + d.b * e.a)
end

function Base.:(/)(d::Dual{T}, e::Dual{T})::Dual{T} where {T}
    return Dual{T}(d.a / e.a, (d.b * e.a - d.a * e.b) / (e.a * e.a))
end

function display(d::Dual{T}) where {T}
    return "$(d.a) + $(d.b)ε"
end

function display!(d::Dual{T})::String where {T}
    display_string = "$(d.a) + $(d.b)ε"
    println(display_string)
    return display_string
end

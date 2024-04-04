function tailor_cos(x::T, n::Integer)::T where {T}
    res = zero(typeof(x))
    ak = 1
    for k in 1:n
        coeff = -(x * x) / (2 * k * (2 * k - 1))
        ak = ak * coeff
        res += ak
    end
    return res
end

function tailor_cos_to_eps(x::T)::T where {T}
    res = zero(typeof(x))
    ak = 1
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
    res = zero(typeof(x))
    ak = 1
    k = 1
    while abs(ak) > Base.eps(typeof(x))
        res += ak
        coeff = x / k
        ak = ak * coeff
        k += 1
    end
    return res
end

function tailor_bessel(x::T, a::Integer=0)::T where {T}
    res = zero(T)
    ak = (x / 2.0)^a / float(factorial(a))
    k = 1
    while abs(ak) > eps(T)
        res += ak
        coeff = -(x * x) / float(4 * k * (k + a))
        ak = ak * coeff
        k += 1
    end
    return res
end

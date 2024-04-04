function my_log(x::T, base::T=2, eps::AbstractFloat=1e-8)::T where {T} # base > 1
    @assert(base > 1)
    @assert(x > 0)
    z = x
    t = 1.0
    y = 0.0
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
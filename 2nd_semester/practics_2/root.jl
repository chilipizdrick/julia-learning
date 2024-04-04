include("./newton.jl")

function root(p::Polynomial{Complex{T}}, x0::Complex{T}, eps::AbstractFloat=1e-8)::Union{Complex{T},Nothing} where {T}
    res = newton_analitical(x -> p(x), x -> valdiff(p, x)[2], x0, eps)
    if abs(p(res)) > eps
        return nothing
    end
    return res
end
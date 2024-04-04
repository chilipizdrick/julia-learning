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
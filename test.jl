function expanded_synthetic_division(dividend, divisor)
    out = copy(dividend)   # Copy the dividend
    normalizer = divisor[1]
    for i in 1:length(dividend)-length(divisor)+1
        out[i] /= normalizer
        coef = out[i]
        if coef != 0 for j in 2:length(divisor)
            out[i+j-1] += -divisor[j] * coef
        end
    end
    separator = 2 - length(divisor)
    return out[1:separator], out[separator:end]   # Return quotient, remainderend
end
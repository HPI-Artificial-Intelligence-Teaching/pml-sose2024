# Library for Arithmetic Coding
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

# Data structure that captures the state of the compressor
mutable struct Compressor
    # bit pattern of the lower bound
    lower::UInt32
    # value of the probability range still in play (in 32-bit fixed point arithmetic)
    range::UInt64
    # bit array of the compressed sequence
    output_bits::BitArray
end
# Default constructor for compression
Compressor() = Compressor(0x00000000, 0x100000000, [])

# compresses a new symbol given by the lower and upper probabilities of the CDF and stores them in the bit-string
function compress!(compressor::Compressor, p_lower, p_upper; bits = 32)
    # compute the new lower and upper boundary
    lower = compressor.lower + UInt32((compressor.range * p_lower) >> bits)
    upper =
        compressor.lower + UInt32(
            (p_upper == (1 << bits)) ? (compressor.range * p_upper - 1) >> bits :
            (compressor.range * p_upper) >> bits,
        )

    # extract all bits that are the same and create more space for the range
    for i = 1:32
        if (lower & 0x80000000 == upper & 0x80000000)
            push!(compressor.output_bits, (lower & 0x80000000) >> 31)
            lower <<= 1
            upper <<= 1
        else
            break
        end
    end

    # update compressor state
    compressor.lower = lower
    compressor.range = upper - lower
    return compressor
end

# flushes the final bits at the end of the string
function flush!(compressor::Compressor)
    k = 0
    # shift back all the dimensions where there is no difference
    while ((compressor.range & (1 << k)) == 0)
        k += 1
    end

    # extract all bits that are the same
    for i = 1:(32-k+1)
        push!(compressor.output_bits, (compressor.lower & 0x80000000) >> 31)
        compressor.lower <<= 1
        compressor.range <<= 1
    end
    compressor.range >>= 1

    return (compressor)
end

# Data structure that captures the state of the decompressor
mutable struct Decompressor
    # bit pattern of the lower bound
    lower::UInt32
    # value of the probability range still in play (in 32-bit fixed point arithmetic)
    range::UInt64
    # current value of the next 32 bits from the compressed sequence
    value::UInt32
    # number of bits processed
    bit_processed::Int
    # number of bits copied
    bits_copied::Int
    # bit array of the compressed sequence
    const input_bits::BitArray
end

# Constructor for the Decompressor
function Decompressor(compressed_bits)
    value = 0
    bits_copied = min(length(compressed_bits), 32)
    for i = 1:32
        value <<= 1
        if (i <= bits_copied)
            value += compressed_bits[i]
        end
    end
    Decompressor(0x00000000, 0x100000000, value, 0, bits_copied, compressed_bits)
end

# de-compresses the next bits from the bitstring and returns the next symbol 
function decompress!(decompressor::Decompressor, P; bits = 32)
    # linearly search for the interval that contains the small number we have
    for i in eachindex(P)
        p_lower = P[i][1]
        p_upper = p_lower + P[i][2]
        lower = decompressor.lower + UInt32((decompressor.range * p_lower) >> bits)
        upper =
            decompressor.lower + UInt32(
                (p_upper == (1 << bits)) ? (decompressor.range * p_upper - 1) >> bits :
                (decompressor.range * p_upper) >> bits,
            )

        if (decompressor.value >= lower && decompressor.value < upper)
            # remove all the bits that are the same from lower and upper
            for i = 1:32
                if (lower & 0x80000000 == upper & 0x80000000)
                    lower <<= 1
                    upper <<= 1
                    decompressor.value <<= 1
                    decompressor.bit_processed += 1
                    if (decompressor.bits_copied < length(decompressor.input_bits))
                        decompressor.bits_copied += 1
                        decompressor.value +=
                            decompressor.input_bits[decompressor.bits_copied]
                    end
                else
                    break
                end
            end

            decompressor.lower = lower
            decompressor.range = upper - lower
            return (i)
        end
    end
end

# rounds the probabilities to fixed point precision
function round_prob(P; bits = 32)
    # base equals 2^bits
    base = 1 << bits

    P_out = Vector{Tuple{UInt,UInt}}(undef, length(P))
    cumP = 0.0
    cumD = 0
    for j in eachindex(P)
        cumP += P[j]
        new_cumD = UInt(round(cumP * base))
        P_out[j] = (cumD, new_cumD - cumD)
        cumD = new_cumD
    end

    # if (sum(map(x -> x[2],P_out)) != base)
    #     println("Discrepancy")
    # end

    return (P_out)
end

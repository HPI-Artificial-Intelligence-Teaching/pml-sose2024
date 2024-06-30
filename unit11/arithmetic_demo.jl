# Code for Arithmetic Coding
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

include("arithmetic.jl")
include("countingmodel.jl")

# reads a file and compresses it using 
function learn_text(file_name; bits = 32)
    # initialize the tokens that we want to predict (including -1 for the EOF)
    tokens = Set{Int16}(collect(0:255))
    push!(tokens, -1)

    # initialize the counting model
    model = CountModel(tokens)

    # initialize the compressor
    compressor = Compressor()

    # count the total log probability (will be the final file size)
    logP = 0.0

    c1 = c2 = c3 = c4 = 0x0
    open(file_name, "r") do file
        for c in collect(readeach(file, UInt8))
            # get the pdf for the next symbol (important for updating lower and upper)
            cum, p =
                round_prob(predict(model, [c1, c2, c3, c4], α = 1 / 256), bits = bits)[model.token_to_idx[c]]
            logP += (log2(p) - log2(1 << bits))

            # compress the character read
            compress!(compressor, cum, cum + p, bits = bits)

            # update the probabilty model of the data
            update!(model, [], c)
            update!(model, [c4], c)
            update!(model, [c3, c4], c)
            update!(model, [c2, c3, c4], c)
            update!(model, [c1, c2, c3, c4], c)

            c1, c2, c3, c4 = c2, c3, c4, c
        end
    end
    # push the EOF character
    cum, p =
        round_prob(predict(model, [c1, c2, c3, c4], α = 1 / 256), bits = bits)[model.token_to_idx[-1]]
    logP += (log2(p) - log2(1 << bits))
    compress!(compressor, cum, cum + p, bits = bits)
    flush!(compressor)

    # print the final stats
    println("[", length(compressor.output_bits), "] ")
    println("\nTarget size of file = ", -logP / 8)

    # initialize the de-compressor
    decompressor = Decompressor(compressor.output_bits)

    # initialize the counting model
    model = CountModel(tokens)

    c1 = c2 = c3 = c4 = 0x0
    c = 0
    while (c != -1)
        P = round_prob(predict(model, [c1, c2, c3, c4], α = 1 / 256), bits = bits)
        c = model.idx_to_token[decompress!(decompressor, P, bits = bits)]
        if (c != -1)
            # Base.print(Char(c))

            # update the probabilty model of the data
            update!(model, [], c)
            update!(model, [c4], c)
            update!(model, [c3, c4], c)
            update!(model, [c2, c3, c4], c)
            update!(model, [c1, c2, c3, c4], c)
            c1, c2, c3, c4 = c2, c3, c4, c
        else
            println()
        end
    end
end

# Test with a simple string
function test_compress(
    line = "CAD",
    prob = [1 / 2, 1 / 4, 1 / 8, 1 / 16, 1 / 64, 1 / 64, 1 / 64, 1 / 64];
    bits = 8,
)
    # initialize the compressor
    compressor = Compressor()

    # compute the rounded probabilities
    P = round_prob(prob, bits = bits)

    # count the total log probability (will be the final file size)
    logP = 0.0

    for c in Vector{Char}(line)
        cum, p = P[Int(c - 'A' + 1)]
        logP += (log2(p) - log2(1 << bits))

        compress!(compressor, cum, cum + p, bits = bits)
    end
    # push the EOF character
    cum, p = P[Int('E' - 'A' + 1)]
    logP += (log2(p) - log2(1 << bits))
    compress!(compressor, cum, cum + p, bits = bits)
    flush!(compressor)

    # print the final stats
    println(
        "[",
        length(compressor.output_bits),
        "] ",
        map(x -> if x
            '1'
        else
            '0'
        end, compressor.output_bits)...,
    )
    println("\nTarget size of file = ", -logP)

    # initialize the de-compressor
    decompressor = Decompressor(compressor.output_bits)

    # compute the rounded probabilities
    P = round_prob(prob, bits = bits)

    c = 'A'
    while (c != 'E')
        c = Char(decompress!(decompressor, P, bits = bits) + Int('A') - 1)
        if (c != 'E')
            Base.print(c)
        else
            println()
        end
    end
end

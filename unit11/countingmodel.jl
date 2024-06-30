# Library for Counting Model with Dirichlet Smoothing for Prediction
#
# 2024 by Ralf Herbrich
# Hasso-Plattner Institute

# Stores a counting model for characters with a context
struct CountModel{T}
    # number of tokens
    no_tokens::Int
    # mapping from a set of integer ids to their respective tokens
    idx_to_token::Dict{Int,T}
    # mapping from a set of tokens to their respective integer ids
    token_to_idx::Dict{T,Int}
    # maps a context string to a sparse list of next characters and their count
    counts::Dict{Int64,Vector{Int}}
end

# Constructor
function CountModel(tokens)
    # number the tokens one-by-one
    no_tokens = length(tokens)
    idx_to_token = Dict{Int,typeof(collect(tokens)[1])}()
    token_to_idx = Dict{typeof(collect(tokens)[1]),Int}()
    i = 1
    for c in tokens
        idx_to_token[i] = c
        token_to_idx[c] = i
        i += 1
    end
    counts = Dict{Int64,Vector{Int}}()
    return CountModel(no_tokens, idx_to_token, token_to_idx, counts)
end

# updates the model from a new character and context
function update!(model::CountModel, context::Vector, symbol)
    # convert the list of symbols in the context into a unique Int64
    con = 0
    for i in eachindex(context)
        con *= (model.no_tokens + 1)
        con += model.token_to_idx[context[end-i+1]]
    end

    if haskey(model.counts, con)
        model.counts[con][model.token_to_idx[symbol]] += 1
    else
        d = zeros(model.no_tokens)
        d[model.token_to_idx[symbol]] = 1
        model.counts[con] = d
    end
    return
end

# computes the Laplace-smoothing of the mixture distribution of the symbol given context
function predict(model::CountModel, context::Vector; α = 1)
    # initialize the probabilities with zero
    P = zeros(model.no_tokens)

    # iterate over all context starting with the empty context
    K = length(context) + 1
    con = 0

    for i = 1:K
        counts = get(model.counts, con, nothing)
        smoothed_counts = (counts !== nothing) ? (counts .+ α) : (α * ones(model.no_tokens))
        total = sum(smoothed_counts)
        P += (smoothed_counts / (K * total))

        # add one more context item
        if (i < K)
            con *= (model.no_tokens + 1)
            con += model.token_to_idx[context[end-i+1]]
        end
    end

    # return the distribution
    return (P)
end

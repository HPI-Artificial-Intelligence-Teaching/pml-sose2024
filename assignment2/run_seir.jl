include("seir.jl");

using .Seir


ps = seir_single_time_series(transition_probs=[0.95 0.05 0.0 0.0; 0.0 0.8 0.2 0.0; 0.0 0.0 0.7 0.3; 0.0 0.0 0.0 1.0]')
display_time_series(ps)
ps = seir_single_time_series(transition_probs=[0.90 0.10 0.0 0.0; 0.0 0.8 0.2 0.0; 0.0 0.0 0.7 0.3; 0.0 0.0 0.0 1.0]')
display_time_series(ps)
ps = seir_single_time_series(transition_probs=[0.85 0.15 0.0 0.0; 0.0 0.8 0.2 0.0; 0.0 0.0 0.7 0.3; 0.0 0.0 0.0 1.0]')
display_time_series(ps)

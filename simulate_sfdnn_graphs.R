simulate_sfdnn_graphs <- function(n, n_graphs, ..., type = "generating", seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  graphs <- lapply(seq_len(n_graphs), function(g) inverse_distance_weights(n, type))
  blocks <- lapply(graphs, function(w) simulate_sfdnn(n, ..., weights = w))
  weights <- structure(list(W = bdiag(lapply(graphs, function(w) w$W)),
                            degree = unlist(lapply(graphs, function(w) w$degree))),
                       class = "sfdnn_weights")
  output <- blocks[[1]]
  output$y <- unlist(lapply(blocks, function(b) b$y))
  output$mu <- unlist(lapply(blocks, function(b) b$mu))
  output$z <- do.call(rbind, lapply(blocks, function(b) b$z))
  output$x <- lapply(1:3, function(p) do.call(rbind, lapply(blocks, function(b) b$x[[p]])))
  output$weights <- weights
  output$graph <- rep(seq_len(n_graphs), each = n)
  output
}
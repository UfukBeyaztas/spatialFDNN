restrict_weights <- function(weights, ids) {
  W <- weights$W[ids, ids, drop = FALSE]
  raw <- if (inherits(W, "Matrix")) {
    Diagonal(x = weights$degree[ids]) %*% W
  } else {
    W * weights$degree[ids]
  }
  spatial_weights(raw)
}

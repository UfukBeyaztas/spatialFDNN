sar_operator <- function(weights, rho) {
  W <- weights$W
  identity <- if (inherits(W, "Matrix")) Diagonal(nrow(W)) else diag(nrow(W))
  identity - rho * W
}
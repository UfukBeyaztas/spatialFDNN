fpca_fit <- function(curves, grid, pve = 0.95) {
  root_weight <- sqrt(trapezoid_weights(grid))
  center <- colMeans(curves)
  weighted <- sweep(sweep(curves, 2, center, "-"), 2, root_weight, "*")
  decomposition <- eigen(crossprod(weighted), symmetric = TRUE)
  values <- pmax(decomposition$values, 0)
  rank <- sum(values > max(values) * 1e-10)
  if (rank == 0) return(list(center = center, projection = matrix(numeric(), ncol(curves), 0)))
  share <- cumsum(values[seq_len(rank)]) / sum(values[seq_len(rank)])
  components <- which(share >= pve)[1]
  if (is.na(components)) components <- rank
  list(center = center,
       projection = decomposition$vectors[, seq_len(components), drop = FALSE] * root_weight)
}

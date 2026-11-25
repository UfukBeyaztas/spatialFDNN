inverse_distance_weights <- function(n, type = c("generating", "truncated", "permuted"),
                                     radius = 5) {
  type <- match.arg(type)
  distance <- abs(outer(seq_len(n), seq_len(n), "-"))
  raw <- 1 / (1 + distance)
  diag(raw) <- 0
  if (type == "truncated") raw <- raw * (distance <= radius)
  if (type == "permuted") {
    order <- sample.int(n)
    raw <- raw[order, order]
  }
  spatial_weights(raw)
}

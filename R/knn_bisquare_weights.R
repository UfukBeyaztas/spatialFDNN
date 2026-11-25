knn_bisquare_weights <- function(coords, k = 8, longlat = TRUE) {
  coords <- as.matrix(coords)
  n <- nrow(coords)
  d <- if (longlat) great_circle_distance(coords) else as.matrix(dist(coords))
  diag(d) <- Inf
  near <- apply(d, 1, function(v) order(v)[seq_len(k + 1)])
  i <- rep(seq_len(n), each = k)
  j <- as.vector(near[seq_len(k), , drop = FALSE])
  bandwidth <- rep(d[cbind(seq_len(n), near[k + 1, ])], each = k)
  w <- pmax((1 - (d[cbind(i, j)] / bandwidth)^2)^2, 1e-8)
  raw <- sparseMatrix(i = i, j = j, x = w, dims = c(n, n))
  mirror <- t(raw)
  spatial_weights(drop0((raw + mirror + abs(raw - mirror)) / 2))
}

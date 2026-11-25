covariate_summaries <- function(x, z = NULL, grid, n_basis = 7) {
  grid <- (grid - min(grid)) / diff(range(grid))
  map <- inner_product_map(grid, n_basis)
  summaries <- do.call(cbind, lapply(x, function(curves) as.matrix(curves) %*% map))
  if (is.null(z)) summaries else cbind(summaries, as.matrix(z))
}

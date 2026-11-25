estimate_rho <- function(y, x, z = NULL, grid, weights, pve = 0.95, bounds = c(-0.99, 0.99)) {
  grid <- (grid - min(grid)) / diff(range(grid))
  bases <- lapply(x, fpca_fit, grid = grid, pve = pve)
  fit <- sar_profile_fit(y, fpc_scores(bases, x, z), weights, bounds)
  fit$bases <- bases
  fit
}
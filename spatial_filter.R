spatial_filter <- function(weights, rho, values) {
  values <- as.matrix(values)
  if (rho == 0) return(values)
  system <- sar_operator(weights, rho)
  as.matrix(if (inherits(system, "Matrix")) solve(system, values) else solve(system, values))
}
predict.sfdnn <- function(object, x, z = NULL, weights, ...) {
  if (!is.list(x)) x <- list(x)
  summaries <- covariate_summaries(x, z, object$grid, object$control$n_basis)
  inputs <- spatial_filter(weights, object$rho, summaries)
  network_forward(object$params, standardize(inputs, object$scaling))$fitted
}
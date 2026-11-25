perturbation_effect <- function(object, x, z = NULL, weights, predictor = 1, delta = 1,
                                sites = NULL, points = NULL, scalar = FALSE) {
  if (!is.list(x)) x <- list(x)
  n <- nrow(as.matrix(x[[1]]))
  if (is.null(sites)) sites <- seq_len(n)
  baseline <- predict(object, x, z, weights)
  if (scalar) {
    z <- as.matrix(z)
    z[sites, predictor] <- z[sites, predictor] + delta
  } else {
    curves <- as.matrix(x[[predictor]])
    if (is.null(points)) points <- seq_len(ncol(curves))
    curves[sites, points] <- sweep(curves[sites, points, drop = FALSE], 2, delta, "+")
    x[[predictor]] <- curves
  }
  predict(object, x, z, weights) - baseline
}
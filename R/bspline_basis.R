bspline_basis <- function(x, size, derivative = 0) {
  interior <- seq(0, 1, length.out = size - 2)
  knots <- c(rep(0, 3), interior, rep(1, 3))
  splineDesign(knots, x, ord = 4, derivs = rep(derivative, length(x)))
}

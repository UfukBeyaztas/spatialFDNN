inner_product_map <- function(grid, n_basis, n_smooth = 31, n_quad = 500) {
  observed <- bspline_basis(grid, n_smooth)
  quadrature <- seq(0, 1, length.out = n_quad)
  weights <- trapezoid_weights(quadrature)
  smooth_values <- bspline_basis(quadrature, n_smooth)
  curvature <- bspline_basis(quadrature, n_smooth, derivative = 2)
  weight_basis <- bspline_basis(quadrature, n_basis)
  penalty <- crossprod(curvature, curvature * weights)
  smoother <- solve(crossprod(observed) + 3e-8 * penalty, t(observed))
  t(smoother) %*% crossprod(smooth_values, weight_basis * weights)
}
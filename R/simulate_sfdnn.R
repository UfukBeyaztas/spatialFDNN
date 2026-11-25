simulate_sfdnn <- function(n, design = c("linear_sar", "nonlinear_sar", "nonlinear_filtered"),
                           rho = 0.5, error = c("gaussian", "t3", "exponential"), sigma = 1,
                           beta0 = 1, n_grid = 101, predictor_ar = NULL, weights = NULL,
                           seed = NULL) {
  design <- match.arg(design)
  error <- match.arg(error)
  if (!is.null(seed)) set.seed(seed)
  if (is.null(predictor_ar)) predictor_ar <- if (design == "linear_sar") 0 else 0.5
  if (is.null(weights)) weights <- inverse_distance_weights(n)
  grid <- seq(0, 1, length.out = n_grid)
  
  k <- 1:5
  basis <- sin(outer(grid, k * pi)) - cos(outer(grid, k * pi))
  score_sd <- 4 * k^(-3 / 2)
  beta <- cbind(sin(2 * pi * grid), cos(2 * pi * grid), 2 * sin(2 * pi * grid))
  quadrature <- trapezoid_weights(grid)
  projection <- crossprod(basis, beta * quadrature)
  projection_sd <- sqrt(colSums((projection * score_sd)^2))
  
  draw_scores <- function() {
    draws <- matrix(rnorm(n * length(k)), n, length(k))
    if (predictor_ar != 0) {
      innovation_sd <- sqrt(1 - predictor_ar^2)
      for (i in 2:n) draws[i, ] <- predictor_ar * draws[i - 1, ] + innovation_sd * draws[i, ]
    }
    sweep(draws, 2, score_sd, "*")
  }
  x <- lapply(1:3, function(p) tcrossprod(draw_scores(), basis))
  z <- matrix(rnorm(n * 3), n, 3)
  projections <- vapply(1:3, function(p) drop(x[[p]] %*% (beta[, p] * quadrature)), numeric(n))
  gamma <- c(1.25, -2, 2.15)
  
  regression <- function(inputs, nonlinear) {
    value <- rowSums(inputs[, 1:3, drop = FALSE]) + drop(inputs[, 4:6, drop = FALSE] %*% gamma)
    if (nonlinear) {
      v1 <- inputs[, 1] / projection_sd[1]
      v2 <- inputs[, 2] / projection_sd[2]
      value <- value + 2 * sin(v1) + 3 * v1 * v2 + 1.5 * (v2^2 - 1) + 2 * tanh(v1 * inputs[, 4])
    }
    beta0 + value
  }
  
  epsilon <- sigma * switch(error,
                            gaussian = rnorm(n),
                            t3 = rt(n, df = 3) / sqrt(3),
                            exponential = rexp(n) - 1
  )
  
  if (design == "nonlinear_filtered") {
    filtered <- spatial_filter(weights, rho, cbind(projections, z, epsilon))
    mu <- regression(filtered[, 1:6, drop = FALSE], nonlinear = TRUE)
    y <- mu + filtered[, 7]
  } else {
    filtered <- spatial_filter(weights, rho,
                               cbind(regression(cbind(projections, z), design == "nonlinear_sar"), epsilon))
    mu <- filtered[, 1]
    y <- mu + filtered[, 2]
  }
  list(y = drop(y), mu = drop(mu), x = x, z = z, grid = grid, beta = beta, weights = weights,
       design = design, rho = rho, error = error)
}

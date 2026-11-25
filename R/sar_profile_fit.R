sar_profile_fit <- function(y, design, weights, bounds = c(-0.99, 0.99)) {
  n <- length(y)
  model_qr <- qr(cbind(1, design))
  if (model_qr$rank >= n - 2) stop("Too few residual degrees of freedom for the working model.")
  wy <- drop(as.matrix(weights$W %*% y))
  e <- qr.resid(model_qr, y)
  ew <- qr.resid(model_qr, wy)
  cross <- c(sum(e^2), sum(e * ew), sum(ew^2))
  eigenvalues <- weight_eigenvalues(weights)
  criterion <- function(rho) {
    variance <- (cross[1] - 2 * rho * cross[2] + rho^2 * cross[3]) / n
    if (!is.finite(variance) || variance <= 0) return(Inf)
    logdet <- if (is.null(eigenvalues)) {
      as.numeric(determinant(sar_operator(weights, rho), logarithm = TRUE)$modulus)
    } else {
      sum(log(Mod(1 - rho * eigenvalues)))
    }
    n * log(variance) / 2 - logdet
  }
  inner <- optimize(criterion, bounds, tol = 1e-6)$minimum
  candidates <- c(bounds[1], inner, bounds[2])
  values <- vapply(candidates, criterion, numeric(1))
  rho <- candidates[which.min(values)]
  theta <- qr.coef(model_qr, y - rho * wy)
  theta[is.na(theta)] <- 0
  if (any(!is.finite(theta)) || !is.finite(min(values))) stop("The working model fit is not finite.")
  list(rho = rho, theta = theta, sigma2 = mean((e - rho * ew)^2),
       boundary = min(abs(rho - bounds)) < 1e-5)
}

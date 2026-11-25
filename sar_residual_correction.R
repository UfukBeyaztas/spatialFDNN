sar_residual_correction <- function(fitted, y, observed, held_out, weights, rho) {
  Q <- crossprod(sar_operator(weights, rho))
  residual <- y[observed] - fitted[observed]
  shift <- solve(Q[held_out, held_out, drop = FALSE],
                 Q[held_out, observed, drop = FALSE] %*% residual)
  fitted[held_out] - as.numeric(shift)
}
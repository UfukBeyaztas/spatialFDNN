rho_sensitivity <- function(object, rho1, rho2, summaries = object$summaries) {
  output_weights <- drop(object$params$w2 %*% object$params$w3)
  input_weights <- object$params$w1 / object$scaling$spread
  lipschitz <- sum(abs(output_weights) * colSums(abs(input_weights))) / 4
  factor <- abs(rho1 - rho2) / ((1 - abs(rho1)) * (1 - abs(rho2)))
  list(lipschitz = lipschitz, filter_factor = factor,
       bound = lipschitz * factor * max(abs(summaries)))
}
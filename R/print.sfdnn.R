print.sfdnn <- function(x, ...) {
  cat("Spatial functional deep neural network\n")
  cat("  sites:", length(x$fitted), "\n")
  cat("  first-stage rho:", format(x$rho, digits = 4),
      if (isTRUE(x$boundary)) "(at the boundary)" else "", "\n")
  cat("  hidden layers:", paste(x$control$hidden, collapse = ", "), "\n")
  cat("  learning rate:", x$learning_rate, " epochs:", x$epochs, "\n")
  cat("  training MSE:", format(mean(x$residuals^2), digits = 4), "\n")
  invisible(x)
}

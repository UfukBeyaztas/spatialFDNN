prediction_error <- function(y, predicted) {
  mse <- mean((y - predicted)^2)
  total <- mean((y - mean(y))^2)
  c(mspe = mse, r2 = if (total > 0) 1 - mse / total else NA)
}

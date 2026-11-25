morans_i <- function(residual, weights) {
  centered <- residual - mean(residual)
  numerator <- sum(centered * as.numeric(weights$W %*% centered))
  denominator <- sum(centered^2) * sum(weights$W)
  if (denominator > 0) length(centered) * numerator / denominator else NA
}

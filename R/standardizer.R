standardizer <- function(inputs) {
  center <- colMeans(inputs)
  spread <- apply(inputs, 2, sd)
  spread[!is.finite(spread) | spread < 1e-10] <- 1
  list(center = center, spread = spread)
}

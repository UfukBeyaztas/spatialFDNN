standardize <- function(inputs, scaling) {
  scale(inputs, center = scaling$center, scale = scaling$spread)
}
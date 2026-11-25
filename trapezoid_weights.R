trapezoid_weights <- function(grid) {
  h <- diff(grid)
  c(h[1], head(h, -1) + tail(h, -1), tail(h, 1)) / 2
}
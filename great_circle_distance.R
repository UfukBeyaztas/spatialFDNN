great_circle_distance <- function(a, b = a) {
  radian <- pi / 180
  half_lon <- outer(a[, 1], b[, 1], "-") * radian / 2
  half_lat <- outer(a[, 2], b[, 2], "-") * radian / 2
  h <- sin(half_lat)^2 + outer(cos(a[, 2] * radian), cos(b[, 2] * radian)) * sin(half_lon)^2
  6371 * 2 * asin(sqrt(pmin(h, 1)))
}
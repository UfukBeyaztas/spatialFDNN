network_gradient <- function(params, inputs, y) {
  layers <- network_forward(params, inputs)
  d3 <- 2 * (layers$fitted - y) / length(y)
  d2 <- tcrossprod(d3, drop(params$w3))
  d1 <- (d2 %*% t(params$w2)) * layers$first * (1 - layers$first)
  list(w1 = crossprod(inputs, d1), b1 = colSums(d1),
       w2 = crossprod(layers$first, d2), b2 = colSums(d2),
       w3 = crossprod(layers$second, d3), b3 = sum(d3))
}
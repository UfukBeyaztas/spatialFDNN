network_forward <- function(params, inputs) {
  first <- plogis(sweep(inputs %*% params$w1, 2, params$b1, "+"))
  second <- sweep(first %*% params$w2, 2, params$b2, "+")
  list(first = first, second = second, fitted = drop(second %*% params$w3) + params$b3)
}

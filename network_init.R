network_init <- function(p, hidden) {
  glorot <- function(a, b) {
    limit <- sqrt(6 / (a + b))
    matrix(runif(a * b, -limit, limit), a, b)
  }
  list(w1 = glorot(p, hidden[1]), b1 = numeric(hidden[1]),
       w2 = glorot(hidden[1], hidden[2]), b2 = numeric(hidden[2]),
       w3 = glorot(hidden[2], 1), b3 = 0)
}
weight_eigenvalues <- function(weights) {
  W <- weights$W
  if (inherits(W, "sparseMatrix")) return(NULL)
  W <- as.matrix(W)
  root <- sqrt(weights$degree)
  similar <- sweep(W * root, 2, root, "/")
  if (max(abs(similar - t(similar))) < 1e-10) {
    return(eigen(similar, symmetric = TRUE, only.values = TRUE)$values)
  }
  eigen(W, only.values = TRUE)$values
}

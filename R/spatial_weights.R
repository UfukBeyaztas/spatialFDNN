spatial_weights <- function(raw) {
  if (nrow(raw) != ncol(raw)) stop("The weight matrix must be square.")
  sparse <- inherits(raw, "Matrix")
  degree <- if (sparse) rowSums(raw) else rowSums(raw)
  divisor <- ifelse(degree > 0, degree, 1)
  W <- if (sparse) Diagonal(x = 1 / divisor) %*% raw else raw / divisor
  structure(list(W = W, degree = divisor), class = "sfdnn_weights")
}

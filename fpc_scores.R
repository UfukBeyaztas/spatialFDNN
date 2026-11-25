fpc_scores <- function(bases, x, z = NULL) {
  scores <- Map(function(basis, curves) {
    sweep(as.matrix(curves), 2, basis$center, "-") %*% basis$projection
  }, bases, x)
  scores <- do.call(cbind, scores)
  if (is.null(z)) scores else cbind(scores, as.matrix(z))
}
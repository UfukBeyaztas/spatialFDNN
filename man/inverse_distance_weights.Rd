\name{inverse_distance_weights}
\alias{inverse_distance_weights}
\title{Weight Matrices of the Simulation Study}
\description{
Generating, truncated, and permuted inverse-distance weight matrices.
}
\usage{
inverse_distance_weights(n, type = c("generating", "truncated", "permuted"),
                         radius = 5)
}
\arguments{
\item{n}{Number of sites.}
\item{type}{Type of matrix.}
\item{radius}{Largest distance in the site index kept by the truncated matrix.}
}
\details{
The sites are indexed along a line, and the raw weight of site \eqn{i'} for
site \eqn{i} is \eqn{1/(1 + |i - i'|)}, with zero diagonal. The generating
matrix uses all pairs. The truncated matrix keeps only the pairs with
\eqn{|i - i'| \le} \code{radius}, which shortens the range of interaction. The
permuted matrix applies a random permutation to the rows and columns of the raw
weights, so it has the same eigenvalues as the generating matrix but attaches
the weights to other pairs of sites. All three are row-standardized. The
permutation uses the current random number stream.
}
\value{
Weight object with a dense matrix.
}
\examples{
\dontrun{
set.seed(1)
dat <- simulate_sfdnn(500, design = "linear_sar", rho = 0.9)
for (type in c("generating", "truncated", "permuted")) {
  w <- inverse_distance_weights(500, type)
  print(estimate_rho(dat$y, dat$x, dat$z, dat$grid, w)$rho)
}
}
}

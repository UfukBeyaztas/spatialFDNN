\name{spatial_weights}
\alias{spatial_weights}
\title{Row-Standardized Spatial Weight Matrix}
\description{
Builds the weight object used by the package from nonnegative raw weights.
}
\usage{
spatial_weights(raw)
}
\arguments{
\item{raw}{Square matrix, dense or sparse, of nonnegative raw weights with
zero diagonal.}
}
\details{
Row \eqn{i} is divided by its sum, \eqn{w_{ii'} = \tilde w_{ii'} / \sum_{i''}
\tilde w_{ii''}}{w_ii' = wtilde_ii' / sum of row i}. Rows without neighbors are
left at zero. For a row-standardized \eqn{W} with zero diagonal,
\eqn{I - \rho W} is nonsingular for \eqn{|\rho| < 1}{|rho| < 1}, and every row
of its inverse sums to \eqn{1/(1-\rho)}{1/(1 - rho)}. The row sums of the raw
weights are kept so that the matrix can be restricted to a subset of sites
and standardized again.
}
\value{
An object of class \code{"sfdnn_weights"}, a list with the standardized matrix
\code{W} and the row sums \code{degree} of the raw weights.
}
\examples{
\dontrun{
# Raw inverse-distance weights of the simulation study for 250 sites
d <- abs(outer(1:250, 1:250, "-"))
raw <- 1 / (1 + d)
diag(raw) <- 0
w <- spatial_weights(raw)
range(rowSums(w$W))
}
}

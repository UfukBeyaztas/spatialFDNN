\name{knn_bisquare_weights}
\alias{knn_bisquare_weights}
\title{Adaptive Bi-Square Nearest-Neighbor Weights}
\description{
Sparse weight matrix from site coordinates, as used for the county data.
}
\usage{
knn_bisquare_weights(coords, k = 8, longlat = TRUE)
}
\arguments{
\item{coords}{Matrix of coordinates with one row per site. With
\code{longlat = TRUE}, the first column is the longitude and the second the
latitude, in degrees.}
\item{k}{Number of neighbors.}
\item{longlat}{Use great-circle distances in kilometers if \code{TRUE} and
Euclidean distances otherwise.}
}
\details{
For site \eqn{i} the bandwidth \eqn{H_i} is the distance to its
\eqn{(k+1)}-st nearest site, and the \eqn{k} nearest sites receive the weights
\eqn{\{1 - (d_{ii'}/H_i)^2\}^2}{(1 - (d_ii'/H_i)^2)^2}. A link present in
either direction keeps the larger of its two weights, and the rows are then
standardized.
}
\value{
Weight object with a sparse matrix.
}
\examples{
\dontrun{
set.seed(1)
coords <- cbind(runif(800, -100, -82), runif(800, 37, 48))
w <- knn_bisquare_weights(coords, k = 8)
dat <- simulate_sfdnn(800, design = "linear_sar", rho = 0.7, weights = w, seed = 2)
estimate_rho(dat$y, dat$x, dat$z, dat$grid, w)$rho
}
}

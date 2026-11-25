\name{spatial_filter}
\alias{spatial_filter}
\title{Spatial Autoregressive Filter}
\description{
Applies \eqn{(I - \rho W)^{-1}}{(I - rho W)^(-1)} to a vector or matrix.
}
\usage{
spatial_filter(weights, rho, values)
}
\arguments{
\item{weights}{Weight object of the sites.}
\item{rho}{Value of \eqn{\rho}{rho}, with \eqn{|\rho| < 1}{|rho| < 1}.}
\item{values}{Vector or matrix with one row per site.}
}
\details{
The filter is computed by solving \eqn{(I - \rho W) V = values}{(I - rho W) V = values},
with a sparse solver when \eqn{W} is sparse. The filtered value at site
\eqn{i} is \eqn{\sum_{i'} a_{ii'} v_{i'}}{sum over i' of a_ii' v_i'}, where
\eqn{a_{ii'}}{a_ii'} are the entries of the inverse, so the values of all sites
contribute. A change of one unit at every site changes every filtered value by
\eqn{1/(1-\rho)}{1/(1 - rho)}.
}
\value{
Matrix of filtered values.
}
\examples{
\dontrun{
w <- inverse_distance_weights(250)
range(spatial_filter(w, 0.9, rep(1, 250)))
}
}

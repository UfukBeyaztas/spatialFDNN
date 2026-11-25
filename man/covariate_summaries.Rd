\name{covariate_summaries}
\alias{covariate_summaries}
\title{B-Spline Summaries of Functional Predictors}
\description{
Computes the inputs of the network before spatial filtering.
}
\usage{
covariate_summaries(x, z = NULL, grid, n_basis = 7)
}
\arguments{
\item{x}{List of functional predictor matrices with one row per site and one
column per grid point.}
\item{z}{Matrix of scalar predictors or \code{NULL}.}
\item{grid}{Common observation grid. It is rescaled to \eqn{[0, 1]}.}
\item{n_basis}{Number of cubic B-spline basis functions \eqn{\psi_{pm}}{psi_pm}
for each functional weight.}
}
\details{
Every observed curve is represented by 31 cubic B-splines with a small
roughness penalty, the representation is evaluated at 500 equally spaced
points, and the inner products
\deqn{s_{ipm} = \int_0^1 \psi_{pm}(u) X_{ip}(u)\, du}{s_ipm = integral of psi_pm(u) X_ip(u) du}
are computed by the trapezoidal rule. Since the functional weights of the
first hidden layer are expanded in the same basis, each first-layer neuron
receives a linear combination of these inner products and of the scalar
predictors. The map from the curve values to the inner products is linear, so
filtering the summaries is the same as summarizing the filtered curves.
}
\value{
Matrix with one row per site. The first columns hold the inner products of
the first functional predictor, then of the second, and so on, followed by the
scalar predictors.
}
\examples{
\dontrun{
dat <- simulate_sfdnn(100, design = "linear_sar", rho = 0.5, seed = 1)
S <- covariate_summaries(dat$x, dat$z, dat$grid)
dim(S)
}
}

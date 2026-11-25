\name{estimate_rho}
\alias{estimate_rho}
\title{First-Stage Estimate of the Spatial Autoregressive Parameter}
\description{
Fits the linear spatial autoregressive working model to functional principal
component scores and scalar predictors by profile maximum likelihood.
}
\usage{
estimate_rho(y, x, z = NULL, grid, weights, pve = 0.95, bounds = c(-0.99, 0.99))
}
\arguments{
\item{y}{Numeric response vector.}
\item{x}{List of functional predictor matrices with one row per site.}
\item{z}{Matrix of scalar predictors or \code{NULL}.}
\item{grid}{Common observation grid.}
\item{weights}{Weight object of the sites.}
\item{pve}{Smallest proportion of variance explained by the retained principal
components of each functional predictor.}
\item{bounds}{Search interval for \eqn{\rho}{rho}.}
}
\details{
Each functional predictor is centered and its principal components are
computed with trapezoidal quadrature weights. The smallest number of components
that explains at least \code{pve} of the variance is kept. With \eqn{X_c} the
matrix of an intercept, the scores, and the scalar predictors, the working
model is
\deqn{(I - \rho W) Y = X_c \theta + \epsilon, \qquad \epsilon \sim N(0, \sigma^2 I).}{(I - rho W) Y = X_c theta + epsilon, epsilon ~ N(0, sigma^2 I).}
For fixed \eqn{\rho}{rho}, \eqn{\theta}{theta} and \eqn{\sigma^2}{sigma^2} are
estimated by least squares, and \eqn{\hat\rho}{rhohat} maximizes
\deqn{\log|I - \rho W| - \frac{n}{2}\log\hat\sigma^2(\rho)}{log|I - rho W| - (n/2) log sigmahat^2(rho)}
over \code{bounds} by a bounded one-dimensional search, with both bounds also
compared. The log-determinant is computed from the eigenvalues of \eqn{W} for a
dense matrix and from a sparse LU decomposition for a sparse matrix.

The criterion is the likelihood of the finite-score working model. Under a
nonlinear regression function the estimate need not recover the generating
\eqn{\rho}{rho}.
}
\value{
A list with components
\item{rho}{Estimate of \eqn{\rho}{rho}.}
\item{theta}{Coefficients of the intercept, the scores, and the scalar
predictors.}
\item{sigma2}{Estimate of the error variance.}
\item{boundary}{\code{TRUE} if the estimate lies at a bound of the search
interval.}
\item{bases}{Mean functions and weighted eigenfunctions of the functional
predictors.}
}
\examples{
\dontrun{
# Linear design: the estimate is close to the generating value
lin <- simulate_sfdnn(500, design = "linear_sar", rho = 0.9, seed = 1)
estimate_rho(lin$y, lin$x, lin$z, lin$grid, lin$weights)$rho

# Nonlinear design: the working model is misspecified
nl <- simulate_sfdnn(500, design = "nonlinear_sar", rho = 0.1, seed = 2)
estimate_rho(nl$y, nl$x, nl$z, nl$grid, nl$weights)$rho

# Truncated weight matrix
w <- inverse_distance_weights(500, "truncated")
estimate_rho(lin$y, lin$x, lin$z, lin$grid, w)$rho
}
}

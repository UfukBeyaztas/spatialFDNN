\name{perturbation_effect}
\alias{perturbation_effect}
\title{Perturbation Contrasts of a Fitted SFDNN}
\description{
Change in the fitted response at every site when one predictor is changed at
selected sites.
}
\usage{
perturbation_effect(object, x, z = NULL, weights, predictor = 1, delta = 1,
                    sites = NULL, points = NULL, scalar = FALSE)
}
\arguments{
\item{object}{Fitted object of class \code{"sfdnn"}.}
\item{x}{List of functional predictor matrices of the sites.}
\item{z}{Matrix of scalar predictors or \code{NULL}.}
\item{weights}{Weight object of the sites.}
\item{predictor}{Index of the functional predictor, or of the scalar predictor
when \code{scalar = TRUE}.}
\item{delta}{Size of the change. For a functional predictor it can be a vector
with one value for each grid point in \code{points}.}
\item{sites}{Sites that are changed. All sites by default.}
\item{points}{Grid points that are changed. All grid points by default.}
\item{scalar}{Change a scalar predictor instead of a functional one.}
}
\details{
The covariate effects of the network have no simple coefficient form, so they
are described by contrasts of the fitted map. A change at one site alters the
inputs of all sites through the corresponding column of
\eqn{(I - \hat\rho W)^{-1}}{(I - rhohat W)^(-1)}. The change at the perturbed
site describes the local effect of the predictor, and the changes at the other
sites describe the spillover. A change applied to all sites shows how the
fitted response depends on a predictor in a given part of its domain, for
example in selected weeks of a season, and the spread of the changes across
sites reflects the nonlinearity of the fit. The contrasts describe the fitted
prediction rule under the chosen weight matrix and are not causal effects.
}
\value{
Numeric vector of changes in the fitted response, one for each site.
}
\examples{
\dontrun{
dat <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
fit <- sfdnn(dat$y, dat$x, dat$z, dat$grid, dat$weights, seed = 2)

# Raise the first functional predictor at all sites on the middle of the domain
mid <- which(dat$grid >= 0.4 & dat$grid <= 0.6)
common <- perturbation_effect(fit, dat$x, dat$z, dat$weights, predictor = 1,
                              delta = 1, points = mid)
summary(common)

# Raise it at site 250 only and look at the spillover
local <- perturbation_effect(fit, dat$x, dat$z, dat$weights, predictor = 1,
                             delta = 1, sites = 250)
plot(abs(1:500 - 250), local, xlab = "distance in the site index",
     ylab = "change in the fitted response")

# Scalar predictor
summary(perturbation_effect(fit, dat$x, dat$z, dat$weights, predictor = 1,
                            delta = 1, scalar = TRUE))
}
}

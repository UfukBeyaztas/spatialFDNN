\name{sar_residual_correction}
\alias{sar_residual_correction}
\title{SAR Residual Correction for Held-Out Sites}
\description{
Adds to the covariate prediction of held-out sites an interpolation of the
residuals at the sites with observed responses.
}
\usage{
sar_residual_correction(fitted, y, observed, held_out, weights, rho)
}
\arguments{
\item{fitted}{Covariate predictions for all sites.}
\item{y}{Response vector for all sites. Entries of the held-out sites are not
used.}
\item{observed}{Indices of the sites with observed responses.}
\item{held_out}{Indices of the sites to be predicted.}
\item{weights}{Weight object of all sites.}
\item{rho}{First-stage estimate of \eqn{\rho}{rho}.}
}
\details{
The regression model describes only the conditional mean. As a working
assumption, the residuals are given the covariance of the spatial
autoregressive model, \eqn{\sigma^2 Q^{-1}}{sigma^2 Q^(-1)} with
\eqn{Q = (I - \rho W)^\top (I - \rho W)}{Q = (I - rho W)' (I - rho W)}. With
\eqn{S} the observed and \eqn{O} the held-out sites, the corrected prediction is
\deqn{\tilde Y_O = \hat\mu_O - Q_{OO}^{-1} Q_{OS} (Y_S - \hat\mu_S).}{Ytilde_O = muhat_O - Q_OO^(-1) Q_OS (Y_S - muhat_S).}
With the true mean and the true \eqn{\rho}{rho}, this is the conditional
expectation of \eqn{Y_O} given \eqn{Y_S} for Gaussian errors and the best
affine predictor otherwise. Here the fitted means and the estimate of
\eqn{\rho}{rho} are plugged in. The network is not changed. The correction
uses the observed responses of the same domain and applies to every method
with a first-stage estimate of \eqn{\rho}{rho}.
}
\value{
Numeric vector of corrected predictions for the sites in \code{held_out}.
}
\examples{
\dontrun{
# Hold out 20 percent of the sites of one graph
dat <- simulate_sfdnn(600, design = "linear_sar", rho = 0.9, seed = 1)
set.seed(2)
held_out <- sort(sample.int(600, 120))
observed <- setdiff(1:600, held_out)

fit <- sfdnn(dat$y[observed], lapply(dat$x, function(m) m[observed, ]),
             dat$z[observed, ], dat$grid, restrict_weights(dat$weights, observed),
             seed = 3)
covariate <- predict(fit, dat$x, dat$z, dat$weights)
corrected <- sar_residual_correction(covariate, dat$y, observed, held_out,
                                     dat$weights, fit$rho)
prediction_error(dat$y[held_out], covariate[held_out])
prediction_error(dat$y[held_out], corrected)
}
}

\name{morans_i}
\alias{morans_i}
\title{Moran's I of Residuals}
\description{
Global Moran's I, used to check for spatial dependence left in the residuals.
}
\usage{
morans_i(residual, weights)
}
\arguments{
\item{residual}{Residual vector.}
\item{weights}{Weight object of the same sites.}
}
\details{
With \eqn{e} the centered residuals,
\eqn{I = n\, e^\top W e / (e^\top e \sum_{ii'} w_{ii'})}{I = n e'We / (e'e sum of all w_ii')}.
Values near zero indicate little remaining spatial dependence under \eqn{W}.
}
\value{
Moran's I.
}
\examples{
\dontrun{
dat <- simulate_sfdnn(600, design = "linear_sar", rho = 0.9, seed = 1)
set.seed(2)
held_out <- sort(sample.int(600, 120))
observed <- setdiff(1:600, held_out)
fit <- sfdnn(dat$y[observed], lapply(dat$x, function(m) m[observed, ]),
             dat$z[observed, ], dat$grid, restrict_weights(dat$weights, observed),
             seed = 3)
covariate <- predict(fit, dat$x, dat$z, dat$weights)
corrected <- covariate
corrected[held_out] <- sar_residual_correction(covariate, dat$y, observed, held_out,
                                               dat$weights, fit$rho)
w_held <- restrict_weights(dat$weights, held_out)
morans_i(dat$y[held_out] - covariate[held_out], w_held)
morans_i(dat$y[held_out] - corrected[held_out], w_held)
}
}

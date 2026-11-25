\name{rho_sensitivity}
\alias{rho_sensitivity}
\title{Sensitivity of SFDNN Predictions to the Value of rho}
\description{
Bound on the change of the fitted values when the filter uses another value of
\eqn{\rho}{rho}, for a fixed network and weight matrix.
}
\usage{
rho_sensitivity(object, rho1, rho2, summaries = object$summaries)
}
\arguments{
\item{object}{Fitted object of class \code{"sfdnn"}.}
\item{rho1, rho2}{Two values in \eqn{(-1, 1)}.}
\item{summaries}{Unfiltered covariate summaries \eqn{S}. The training summaries
by default.}
}
\details{
Write the fitted network as
\eqn{h(x) = c_0 + \sum_\ell \alpha_\ell \sigma\{\omega_\ell^\top \Delta^{-1}(x - \kappa) + b_\ell\}}{h(x) = c0 + sum_l alpha_l sigma(omega_l' Delta^(-1) (x - kappa) + b_l)}
and let \eqn{x_i(\rho)} be the \eqn{i}-th row of
\eqn{(I - \rho W)^{-1} S}{(I - rho W)^(-1) S}. Since the derivative of the
sigmoid is at most \eqn{1/4}, \eqn{h} is Lipschitz in the sup norm with constant
\deqn{L = \frac{1}{4}\sum_\ell |\alpha_\ell|\, \|\Delta^{-1}\omega_\ell\|_1.}{L = (1/4) sum_l |alpha_l| ||Delta^(-1) omega_l||_1.}
With \eqn{\|W\|_\infty = 1}{||W||_inf = 1}, the identity
\eqn{A_{\rho_1} - A_{\rho_2} = (\rho_1 - \rho_2) A_{\rho_1} W A_{\rho_2}}{A_rho1 - A_rho2 = (rho1 - rho2) A_rho1 W A_rho2}
and the Neumann series give
\deqn{\max_i |h\{x_i(\rho_1)\} - h\{x_i(\rho_2)\}| \le
\frac{L\,|\rho_1 - \rho_2|\,\max_{ik}|S_{ik}|}{(1 - |\rho_1|)(1 - |\rho_2|)}.}{max_i |h(x_i(rho1)) - h(x_i(rho2))| <= L |rho1 - rho2| max|S| / ((1 - |rho1|)(1 - |rho2|)).}
For \eqn{\rho_1, \rho_2 \ge 0}{rho1, rho2 >= 0} the filter factor is attained
by spatially constant summaries. The factor grows quickly as the dependence
becomes strong. A change from 0.85 to 0.90 gives about fifty times the factor
of a change from 0.10 to 0.15. The bound keeps the network, the
standardization, and the weight matrix fixed and does not describe a refit.
}
\value{
A list with components
\item{lipschitz}{Lipschitz constant \eqn{L} of the fitted network.}
\item{filter_factor}{\eqn{|\rho_1 - \rho_2|/\{(1 - |\rho_1|)(1 - |\rho_2|)\}}{|rho1 - rho2| / ((1 - |rho1|)(1 - |rho2|))}.}
\item{bound}{Bound on the largest change of the fitted values.}
}
\examples{
\dontrun{
dat <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
fit <- sfdnn(dat$y, dat$x, dat$z, dat$grid, dat$weights, seed = 2)

# Fitted rho against the generating value
rho_sensitivity(fit, fit$rho, 0.9)

# The same change of rho under weak and strong dependence
rho_sensitivity(fit, 0.10, 0.15)$filter_factor
rho_sensitivity(fit, 0.85, 0.90)$filter_factor
}
}

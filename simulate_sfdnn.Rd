\name{simulate_sfdnn}
\alias{simulate_sfdnn}
\title{Data of the Simulation Study}
\description{
Generates spatially dependent data with three functional and three scalar
predictors from the linear, nonlinear SAR, and nonlinear filtered designs.
}
\usage{
simulate_sfdnn(n, design = c("linear_sar", "nonlinear_sar", "nonlinear_filtered"),
               rho = 0.5, error = c("gaussian", "t3", "exponential"), sigma = 1,
               beta0 = 1, n_grid = 101, predictor_ar = NULL, weights = NULL,
               seed = NULL)
}
\arguments{
\item{n}{Number of sites.}
\item{design}{Data-generating design.}
\item{rho}{Spatial autoregressive parameter. The study uses 0.1, 0.5, and 0.9.}
\item{error}{Error distribution. The \eqn{t_3} and exponential errors are
centered and scaled to have mean zero and variance \code{sigma^2}.}
\item{sigma}{Error standard deviation.}
\item{beta0}{Intercept.}
\item{n_grid}{Number of equally spaced grid points on \eqn{[0, 1]}.}
\item{predictor_ar}{Autocorrelation of the principal component scores along the
site index. By default 0 in the linear design and 0.5 in the nonlinear
designs.}
\item{weights}{Weight object of the sites. By default the generating
inverse-distance matrix.}
\item{seed}{Seed or \code{NULL}.}
}
\details{
Each functional predictor is
\eqn{X_p(u) = \sum_{j=1}^5 \zeta_j \{\sin(j\pi u) - \cos(j\pi u)\}}{X_p(u) = sum over j = 1..5 of zeta_j (sin(j pi u) - cos(j pi u))}
with independent \eqn{\zeta_j \sim N\{0, (4 j^{-3/2})^2\}}{zeta_j ~ N(0, (4 j^(-3/2))^2)}.
The coefficient functions are \eqn{\sin(2\pi u)}{sin(2 pi u)},
\eqn{\cos(2\pi u)}{cos(2 pi u)}, and \eqn{2\sin(2\pi u)}{2 sin(2 pi u)}, the
three scalar predictors are standard normal, and
\eqn{\Gamma = (1.25, -2, 2.15)}{Gamma = (1.25, -2, 2.15)}. Let
\eqn{L_p = \int_0^1 X_p(u)\beta_p(u)\,du}{L_p = integral of X_p(u) beta_p(u) du}
and \eqn{A_\rho = (I - \rho W)^{-1}}{A_rho = (I - rho W)^(-1)}.

In the linear design
\eqn{Y = A_\rho(\beta_0 + L_1 + L_2 + L_3 + Z\Gamma + \epsilon)}{Y = A_rho (beta0 + L1 + L2 + L3 + Z Gamma + epsilon)},
and the intercept contributes \eqn{\beta_0/(1-\rho)}{beta0/(1 - rho)} to the mean
of every site. The nonlinear designs use
\deqn{g = \beta_0 + \sum_p L_p + Z\Gamma + 2\sin(v_1) + 3 v_1 v_2 + 1.5(v_2^2 - 1) + 2\tanh(v_1 z_1),}{g = beta0 + sum_p L_p + Z Gamma + 2 sin(v1) + 3 v1 v2 + 1.5 (v2^2 - 1) + 2 tanh(v1 z1),}
with \eqn{v_p = L_p / \mathrm{sd}(L_p)}{v_p = L_p / sd(L_p)}. In the nonlinear
SAR design \eqn{Y = A_\rho(g + \epsilon)}{Y = A_rho (g + epsilon)}, so the
nonlinear function acts before the filter. In the nonlinear filtered design
\eqn{g} is evaluated at the filtered \eqn{L_p} and \eqn{Z}, and
\eqn{A_\rho\epsilon}{A_rho epsilon} is added, which is the structure assumed
by SFDNN. In the nonlinear designs the scores follow stationary first-order
autoregressions along the site index with the same marginal variances, so that
neighboring sites have similar curves.

The study uses 100, 250, and 500 training sites and test samples of 1000
sites. The random numbers are drawn in the same order as in the study, so a
given seed reproduces a data set exactly.
}
\value{
A list with components
\item{y}{Response vector.}
\item{mu}{Conditional mean of the response given the predictors.}
\item{x}{List of three matrices of functional predictors, sites by grid
points.}
\item{z}{Matrix of the three scalar predictors.}
\item{grid}{Observation grid.}
\item{beta}{Matrix of the coefficient functions on the grid.}
\item{weights}{Weight object used to generate the data.}
\item{design, rho, error}{Settings of the data set.}
}
\examples{
\dontrun{
# The 45 settings of the study
settings <- rbind(
  expand.grid(design = "linear_sar", error = c("gaussian", "t3", "exponential"),
              n = c(100, 250, 500), rho = c(0.1, 0.5, 0.9), stringsAsFactors = FALSE),
  expand.grid(design = c("nonlinear_sar", "nonlinear_filtered"), error = "gaussian",
              n = c(100, 250, 500), rho = c(0.1, 0.5, 0.9), stringsAsFactors = FALSE))
nrow(settings)

# One replication of one setting
train <- simulate_sfdnn(250, design = "linear_sar", rho = 0.9, error = "exponential",
                        seed = 1)
test <- simulate_sfdnn(1000, design = "linear_sar", rho = 0.9, error = "exponential",
                       seed = 2)
matplot(train$grid, t(train$x[[1]][1:50, ]), type = "l", lty = 1,
        xlab = "u", ylab = "first functional predictor")

# Oracle prediction error of the test sample
prediction_error(test$y, test$mu)
}
}

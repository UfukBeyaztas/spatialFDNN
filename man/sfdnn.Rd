\name{sfdnn}
\alias{sfdnn}
\alias{print.sfdnn}
\title{Fit a Spatial Functional Deep Neural Network}
\description{
Fits a neural network to spatially filtered summaries of functional and scalar
predictors.
}
\usage{
sfdnn(y, x, z = NULL, grid, weights, control = sfdnn_control(), seed = NULL)

\method{print}{sfdnn}(x, ...)
}
\arguments{
\item{y}{Numeric response vector with one value per site.}
\item{x}{For \code{sfdnn}, a list of matrices, one for each functional predictor,
with one row per site and one column per grid point. A single matrix is
treated as one functional predictor. For \code{print}, a fitted object.}
\item{z}{Matrix of scalar predictors with one row per site, or \code{NULL}.}
\item{grid}{Common observation grid of the functional predictors. It is
rescaled to \eqn{[0, 1]}.}
\item{weights}{Weight object of the training sites, as returned by
\code{spatial_weights}.}
\item{control}{List of settings from \code{sfdnn_control}.}
\item{seed}{Seed for the validation split and for the starting values of the
network, or \code{NULL}.}
\item{...}{Not used.}
}
\details{
The fitted value at site \eqn{i} is
\deqn{\hat Y_i = c_0 + \sum_{\ell} \alpha_\ell\, \sigma\{\omega_\ell^\top
\Delta^{-1}(x_i - \kappa) + b_\ell\},}{Yhat_i = c0 + sum_l alpha_l sigma(omega_l' Delta^(-1) (x_i - kappa) + b_l),}
where \eqn{x_i} is the \eqn{i}-th row of
\eqn{(I - \hat\rho W)^{-1} S}{(I - rhohat W)^(-1) S}, \eqn{S} collects the
B-spline inner products of the functional predictors and the scalar
predictors, \eqn{\sigma}{sigma} is the sigmoid function, and \eqn{\kappa}{kappa}
and \eqn{\Delta}{Delta} are the means and standard deviations used for
standardization. The second hidden layer is linear, so the network is a linear
combination of sigmoid functions of the filtered summaries.

A share \code{control$validation} of the sites is set aside at random. On the
remaining sites \eqn{\rho}{rho} is estimated with the weight matrix restricted
to them and standardized again, and a network is trained for every candidate
learning rate. Mini-batch Adam updates are made in every epoch, the validation
error is computed after each epoch, and training stops when this error has not
decreased for \code{control$patience} epochs. The responses of the validation
sites enter only the validation error, whereas their covariates enter the
filter. The learning rate with the smallest validation error is kept together
with its best epoch. Finally \eqn{\rho}{rho} is estimated from all sites, the
summaries are filtered and standardized again, and the network is trained on
all sites for the selected number of epochs.

The first-stage estimate maximizes the likelihood of a working model and need
not recover the generating \eqn{\rho}{rho} when the regression function is
nonlinear. It is reported relative to the weight matrix used for fitting.
}
\value{
An object of class \code{"sfdnn"}, a list with components
\item{params}{Weights and biases of the fitted network.}
\item{scaling}{Means and standard deviations of the filtered summaries.}
\item{rho}{First-stage estimate of \eqn{\rho}{rho}.}
\item{boundary}{\code{TRUE} if the estimate lies at a bound of the search
interval.}
\item{learning_rate}{Selected learning rate.}
\item{epochs}{Selected number of epochs.}
\item{fitted}{Fitted values at the training sites.}
\item{residuals}{Training residuals.}
\item{summaries}{Unfiltered covariate summaries of the training sites.}
\item{control}{Settings used for the fit.}
\item{grid}{Observation grid.}
\code{print} returns its argument invisibly.
}
\examples{
\dontrun{
# Nonlinear filtered design with strong dependence and 500 training sites
train <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
test <- simulate_sfdnn(1000, design = "nonlinear_filtered", rho = 0.9, seed = 2)

fit <- sfdnn(train$y, train$x, train$z, train$grid, train$weights, seed = 3)
fit
prediction_error(train$y, fit$fitted)
prediction_error(test$y, predict(fit, test$x, test$z, test$weights))

# Linear design with t3 errors
lin <- simulate_sfdnn(250, design = "linear_sar", rho = 0.5, error = "t3", seed = 4)
fit_lin <- sfdnn(lin$y, lin$x, lin$z, lin$grid, lin$weights, seed = 5)
fit_lin$rho
}
}

\name{spatialFDNN-package}
\alias{spatialFDNN-package}
\alias{spatialFDNN}
\docType{package}
\title{Spatial Functional Deep Neural Networks}
\description{
Prediction of a scalar response from functional and scalar predictors observed
at spatial locations, with a neural network fitted to spatially filtered
covariates.
}
\details{
Let \eqn{W} be a row-standardized spatial weight matrix and
\eqn{A_\rho = (I - \rho W)^{-1}}{A_rho = (I - rho W)^(-1)}. The model assumes
that the conditional mean of the response at site \eqn{i} is an unknown
function of the functional and scalar predictors of site \eqn{i} after they
have been filtered with \eqn{A_\rho}{A_rho}, so that the predictors of all other
sites enter through the weights of \eqn{A_\rho}{A_rho}. The linear spatial
scalar-on-function regression model is a special case. The nonlinear spatial
autoregressive model, in which the filter is applied after the nonlinear
regression function, shares the same mean for every predictor configuration
only when that function is affine.

Estimation has two stages. The parameter \eqn{\rho}{rho} is estimated by
maximizing the Gaussian profile likelihood of a linear spatial autoregressive
working model built on functional principal component scores. Each functional
predictor is then summarized by its inner products with a cubic B-spline basis,
the summaries and the scalar predictors are filtered with
\eqn{A_{\hat\rho}}{A_rhohat}, and a network with a sigmoid hidden layer and a
linear hidden layer is trained on the standardized filtered summaries by Adam.
The learning rate and the number of epochs are chosen on a random validation
set. Under a nonlinear model the first-stage estimate is the dependence
parameter of the working model and need not recover the generating
\eqn{\rho}{rho}.

For held-out sites whose neighbors have observed responses, the residuals of
the observed sites can be interpolated under the covariance of the spatial
autoregressive model. Perturbations of the fitted network describe how the
fitted response changes with a predictor at one site or at all sites.

The main functions are \code{sfdnn} and its \code{predict} method,
\code{sar_residual_correction}, \code{perturbation_effect}, and
\code{rho_sensitivity}. \code{simulate_sfdnn} and \code{simulate_sfdnn_graphs}
generate the data of the simulation study, and \code{inverse_distance_weights}
and \code{knn_bisquare_weights} build weight matrices.
}
\author{
Ufuk Beyaztas

Maintainer: Ufuk Beyaztas <ufuk.beyaztas@marmara.edu.tr>
}
\keyword{package}
\examples{
\dontrun{
train <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
test <- simulate_sfdnn(1000, design = "nonlinear_filtered", rho = 0.9, seed = 2)

fit <- sfdnn(train$y, train$x, train$z, train$grid, train$weights, seed = 3)
fit

pred <- predict(fit, test$x, test$z, test$weights)
prediction_error(test$y, pred)
prediction_error(test$y, test$mu)
}
}

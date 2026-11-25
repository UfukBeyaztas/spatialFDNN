\name{predict.sfdnn}
\alias{predict.sfdnn}
\title{Covariate Prediction with a Fitted SFDNN}
\description{
Predicts the response at a set of sites from their functional and scalar
predictors.
}
\usage{
\method{predict}{sfdnn}(object, x, z = NULL, weights, ...)
}
\arguments{
\item{object}{Fitted object of class \code{"sfdnn"}.}
\item{x}{List of functional predictor matrices of the sites, observed on the
grid used for fitting.}
\item{z}{Matrix of scalar predictors or \code{NULL}.}
\item{weights}{Weight object of the sites in \code{x}.}
\item{...}{Not used.}
}
\details{
The covariate summaries of the sites are filtered with
\eqn{(I - \hat\rho W)^{-1}}{(I - rhohat W)^(-1)} for the weight matrix in
\code{weights}, standardized with the training means and standard deviations,
and passed through the fitted network. When the new sites form their own graph,
\code{weights} is the matrix of the new sites. When some sites of the training
domain were held out, pass the predictors and the weight matrix of all sites,
so that the held-out sites are filtered together with their observed neighbors.
}
\value{
Numeric vector of predictions, one for each row of the predictor matrices.
}
\examples{
\dontrun{
train <- simulate_sfdnn(500, design = "nonlinear_sar", rho = 0.9, seed = 1)
fit <- sfdnn(train$y, train$x, train$z, train$grid, train$weights, seed = 2)

# One test graph of 1000 sites
test <- simulate_sfdnn(1000, design = "nonlinear_sar", rho = 0.9, seed = 3)
prediction_error(test$y, predict(fit, test$x, test$z, test$weights))

# Two test graphs of the training size
matched <- simulate_sfdnn_graphs(500, 2, design = "nonlinear_sar", rho = 0.9, seed = 4)
prediction_error(matched$y, predict(fit, matched$x, matched$z, matched$weights))
}
}

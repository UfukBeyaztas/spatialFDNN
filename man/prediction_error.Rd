\name{prediction_error}
\alias{prediction_error}
\title{Mean Squared Prediction Error and R-Squared}
\description{
Accuracy measures used in the simulations and in the application.
}
\usage{
prediction_error(y, predicted)
}
\arguments{
\item{y}{Observed responses.}
\item{predicted}{Predicted responses.}
}
\details{
The mean squared prediction error is
\eqn{n^{-1}\sum_i (Y_i - \hat Y_i)^2}{mean of (Y_i - Yhat_i)^2}, and
\eqn{R^2 = 1 - \sum_i (Y_i - \hat Y_i)^2 / \sum_i (Y_i - \bar Y)^2}{R^2 = 1 - sum (Y_i - Yhat_i)^2 / sum (Y_i - Ybar)^2}.
On a test sample \eqn{R^2} is negative when the prediction error exceeds the
variance of the test responses.
}
\value{
Named vector with \code{mspe} and \code{r2}.
}
\examples{
\dontrun{
test <- simulate_sfdnn(1000, design = "nonlinear_sar", rho = 0.5, seed = 1)
prediction_error(test$y, test$mu)
}
}

\name{sfdnn_control}
\alias{sfdnn_control}
\title{Settings for Fitting SFDNN}
\description{
Collects the network architecture, the training settings, and the settings of
the first-stage working model.
}
\usage{
sfdnn_control(hidden = c(64, 64), n_basis = 7, epochs = 400, batch = 32,
              patience = 30, learning_rates = c(0.001, 0.01), validation = 0.2,
              pve = 0.95, bounds = c(-0.99, 0.99))
}
\arguments{
\item{hidden}{Numbers of neurons in the sigmoid and in the linear hidden layer.}
\item{n_basis}{Number of cubic B-spline basis functions for each functional
weight.}
\item{epochs}{Largest number of epochs.}
\item{batch}{Mini-batch size.}
\item{patience}{Number of epochs without a decrease of the validation error
after which training stops.}
\item{learning_rates}{Candidate learning rates for Adam.}
\item{validation}{Share of the training sites used for validation.}
\item{pve}{Smallest proportion of variance explained by the principal
components of each functional predictor in the working model.}
\item{bounds}{Search interval for \eqn{\rho}{rho}. For a row-standardized
weight matrix it should lie inside \eqn{(-1, 1)}.}
}
\details{
The defaults are the settings of the simulation study and of the corn yield
application.
}
\value{
A list with the arguments as components.
}
\examples{
\dontrun{
# Smaller network and shorter training for a quick look at the data
quick <- sfdnn_control(hidden = c(16, 16), epochs = 100, patience = 15)
dat <- simulate_sfdnn(250, design = "linear_sar", rho = 0.9, seed = 1)
fit <- sfdnn(dat$y, dat$x, dat$z, dat$grid, dat$weights, control = quick, seed = 2)
fit
}
}

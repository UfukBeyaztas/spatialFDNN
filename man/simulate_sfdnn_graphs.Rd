\name{simulate_sfdnn_graphs}
\alias{simulate_sfdnn_graphs}
\title{Simulated Sample Made of Independent Graphs}
\description{
Stacks several independent simulated data sets, each on its own graph.
}
\usage{
simulate_sfdnn_graphs(n, n_graphs, ..., type = "generating", seed = NULL)
}
\arguments{
\item{n}{Number of sites in each graph.}
\item{n_graphs}{Number of graphs.}
\item{...}{Arguments passed to \code{simulate_sfdnn}, such as \code{design},
\code{rho}, and \code{error}. Do not pass \code{weights} or \code{seed}.}
\item{type}{Type of the inverse-distance weight matrix of each graph.}
\item{seed}{Seed or \code{NULL}.}
}
\details{
The distribution of the filtered covariates depends on the size of the graph.
In the nonlinear designs of the study the fitted models are therefore also
evaluated on test samples of 1000 sites made of independent graphs of the
training size, that is, 10, 4, and 2 graphs for 100, 250, and 500 training
sites. The weight matrix of the stacked sample is block diagonal.
}
\value{
A list as returned by \code{simulate_sfdnn}, with a block-diagonal sparse
weight matrix and a vector \code{graph} that gives the graph of every site.
}
\examples{
\dontrun{
train <- simulate_sfdnn(250, design = "nonlinear_filtered", rho = 0.9, seed = 1)
matched <- simulate_sfdnn_graphs(250, 4, design = "nonlinear_filtered", rho = 0.9,
                                 seed = 2)
table(matched$graph)

fit <- sfdnn(train$y, train$x, train$z, train$grid, train$weights, seed = 3)
prediction_error(matched$y, predict(fit, matched$x, matched$z, matched$weights))
}
}

\name{restrict_weights}
\alias{restrict_weights}
\title{Restrict a Weight Matrix to a Subset of Sites}
\description{
Gives the weight matrix of the training sites when some sites are held out.
}
\usage{
restrict_weights(weights, ids)
}
\arguments{
\item{weights}{Weight object of all sites.}
\item{ids}{Indices of the sites to keep.}
}
\details{
The raw weights between the selected sites are recovered from the stored row
sums, and the rows are standardized again. This is how the weight matrix of
the training counties is formed in the held-out-county comparison, and how
\code{sfdnn} forms the matrix of the fitting sites during validation.
}
\value{
Weight object of the selected sites.
}
\examples{
\dontrun{
w <- inverse_distance_weights(500)
held_out <- sort(sample.int(500, 100))
w_train <- restrict_weights(w, setdiff(1:500, held_out))
dim(w_train$W)
}
}

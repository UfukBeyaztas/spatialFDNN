\name{great_circle_distance}
\alias{great_circle_distance}
\title{Great-Circle Distances}
\description{
Distances in kilometers between points given by longitude and latitude.
}
\usage{
great_circle_distance(a, b = a)
}
\arguments{
\item{a, b}{Matrices with the longitude in the first and the latitude in the
second column, in degrees.}
}
\details{
The haversine formula is used with an earth radius of 6371 kilometers.
}
\value{
Matrix of distances between the rows of \code{a} and the rows of \code{b}.
}
\examples{
\dontrun{
# Ames, Iowa, and Lincoln, Nebraska
pts <- rbind(c(-93.62, 42.03), c(-96.70, 40.81))
great_circle_distance(pts)
}
}

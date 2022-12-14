% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ryx.R
\name{print.ryx}
\alias{print.ryx}
\title{Prints the correlation table}
\usage{
\method{print}{ryx}(x, digits = 3)
}
\arguments{
\item{x}{The list result from the ryx function}

\item{digits}{The number of digits we want to see in numbers within the correlation table}
}
\value{
A correlation table
}
\description{
Prints the correlation table
}
\examples{
\dontrun{
library(MASS)
x <- ryx(Boston, y="medv")
print.ryx(x, digits = 3)
}
}

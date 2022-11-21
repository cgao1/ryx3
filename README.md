# rxy

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

![](tools.jpg)

The goal of rxy is to provide an easy way to obtain results for correlation.

## Installation

You can install the development version of rxy like so:

``` r
if(!require("remotes")){
install.packages("remotes")
}
remotes::install_github("cgao1/rxy2")
```

## Example

This is a basic example which shows you how to solve use the package after installation:

``` r
library(rxy)
library(MASS)
x<-ryx(Boston,"medv")
print.ryx(x)
summary.ryx(x)
plot.ryx(X)
```

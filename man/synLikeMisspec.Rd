% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/synLikeMisspec.R
\name{synLikeMisspec}
\alias{synLikeMisspec}
\title{Estimate the Gaussian synthetic (log) likelihood whilst acknowledging model
incompatibility}
\usage{
synLikeMisspec(
  ssy,
  ssx,
  type = c("mean", "variance"),
  gamma = numeric(length(ssy)),
  log = TRUE,
  verbose = FALSE
)
}
\arguments{
\item{ssy}{The observed summary statisic.}

\item{ssx}{A matrix of the simulated summary statistics. The number
of rows is the same as the number of simulations per iteration.}

\item{type}{A string argument indicating which method is used to account for
and detect potential incompatibility. The two options are "mean" and
"variance" for mean adjustment and variance inflation, respectively.}

\item{gamma}{The additional latent parameter to account for possible
 incompatability between the model and observed summary statistic. In
 ``BSLmisspec'' method, this is updated with a slice sampler
 \insertCite{Neal2003}{BSL}. The default gamma implies no model misspecification
and is equivalent to the standard \code{\link{gaussianSynLike}} estimator.}

\item{log}{A logical argument indicating if the log of likelihood is
given as the result. The default is \code{TRUE}.}

\item{verbose}{A logical argument indicating whether an error message
should be printed if the function fails to compute a likelihood. The
default is \code{FALSE}.}
}
\value{
The estimated synthetic (log) likelihood value.
}
\description{
This function estimates the Gaussian synthetic likelihood whilst
  acknowledging that there may be incompatibility between the model and the
  observed summary statistic. The method has two different ways to
  account for and detect incompatibility (mean adjustment and variance
  inflation). An additional free parameter \code{gamma} is employed to account for the
  model misspecification. See the R-BSL methods of
  \insertCite{Frazier2019;textual}{BSL} for more details. Note this function
  is mainly designed for interal use as the latent variable \code{gamma} need
  to be chosen otherwise. Alternatively, \code{gamma} is updated with a slice
  sampler \insertCite{Neal2003}{BSL}, which is the method of
  \insertCite{Frazier2019;textual}{BSL}.
}
\examples{
# a toy model (for details see section 4.1 from Frazier et al 2019)
# the true underlying model is a normal distribution with standard deviation equals to 0.2
# whist the data generation process has the standard deviation fixed to 1
set.seed(1)
y <- rnorm(50, 1, sd = 0.2)
ssy <- c(mean(y), var(y))
m <- newModel(fnSim = function(theta) rnorm(50, theta), fnSum = function(x) c(mean(x), var(x)),
              theta0 = 1, fnLogPrior = function(x) log(dnorm(x, sd = sqrt(10))))
ssx <- simulation(m, n = 300, theta = 1, seed = 10)$ssx

# gamma is updated with a slice sampler
gamma <- rep(0.1, length(ssy))
synLikeMisspec(ssy, ssx, type = "variance", gamma = gamma)

}
\references{
\insertAllCited{}
}
\seealso{
Other available synthetic likelihood estimators:
  \code{\link{gaussianSynLike}} for the standard synthetic likelihood
  estimator, \code{\link{gaussianSynLikeGhuryeOlkin}} for the unbiased
  synthetic likelihood estimator, \code{\link{semiparaKernelEstimate}} for
  the semi-parametric likelihood estimator, \code{\link{synLikeMisspec}} for
  the Gaussian synthetic likelihood estimator for model misspecification.
  Slice sampler to sample gamma \code{\link{sliceGammaMean}} and
  \code{\link{sliceGammaVariance}} (internal functions).
}

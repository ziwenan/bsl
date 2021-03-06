% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimateWhiteningMatrix.R
\name{estimateWhiteningMatrix}
\alias{estimateWhiteningMatrix}
\title{Estimate the Whitening matrix to be used in the ``wBSL'' method of
\insertCite{Priddle2019;textual}{BSL}}
\usage{
estimateWhiteningMatrix(
  n,
  model,
  method = c("PCA", "ZCA", "Cholesky", "ZCA-cor", "PCA-cor"),
  thetaPoint = NULL,
  parallel = FALSE,
  parallelArgs = NULL
)
}
\arguments{
\item{n}{The number of model simulations to estimate the Whitening matrix.}

\item{model}{A ``MODEL'' object generated with function
\code{newModel}. See \code{\link{newModel}}.}

\item{method}{The type of Whitening method to be used. The default is
``PCA''.}

\item{thetaPoint}{A point estimate of the parameter value with non-negligible
posterior support.}

\item{parallel}{A logical value indicating whether parallel computing should
be used for simulation and summary statistic evaluation. The default is
\code{FALSE}. When model simulation is fast, it may be preferable to
perform serial or vectorised computations to avoid significant
communication overhead between workers. Parallel computation can only be
used if not using a vectorised simulation function, see \code{\link{MODEL}}
for options of vectorised simulation function.}

\item{parallelArgs}{A list of additional arguments to pass into the
\code{foreach} function. Only used when parallel computing is enabled,
default is \code{NULL}.}
}
\value{
The estimated Whitening matrix.
}
\description{
This function estimates the Whitening matrix to be used in BSL
  with Warton's shrinkage and Whitening (``wBSL'' method of
  \insertCite{Priddle2019;textual}{BSL}). The Whitening transformation and
  decorrelation methods are detailed in \insertCite{Kessy2018;textual}{BSL}.
}
\examples{
\dontshow{
data(ma2)
model <- newModel(fnSim = ma2_sim, fnSum = ma2_sum, simArgs = ma2$sim_args, theta0 = ma2$start)
W <- estimateWhiteningMatrix(500, model, method = "PCA", thetaPoint = c(0.6, 0.2))
}
\dontrun{
data(ma2)
model <- newModel(fnSim = ma2_sim, fnSum = ma2_sum, simArgs = ma2$sim_args, theta0 = ma2$start)
W <- estimateWhiteningMatrix(20000, model, method = "PCA", thetaPoint = c(0.6, 0.2))
}

}
\references{
\insertAllCited{}
}

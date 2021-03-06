% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/s4-MODEL.R
\docType{class}
\name{MODEL-class}
\alias{MODEL-class}
\alias{MODEL}
\alias{newModel}
\alias{simulation,MODEL-method}
\alias{summStat,ANY,MODEL-method}
\title{S4 class ``MODEL''}
\usage{
newModel(
  fnSim,
  fnSimVec,
  fnSum,
  fnLogPrior,
  simArgs,
  sumArgs,
  theta0,
  thetaNames,
  test = TRUE,
  verbose = TRUE
)

\S4method{simulation}{MODEL}(
  model,
  n = 1,
  theta = model@theta0,
  summStat = TRUE,
  parallel = FALSE,
  parallelArgs = NULL,
  seed = NULL
)

\S4method{summStat}{ANY,MODEL}(x, model)
}
\arguments{
\item{fnSim}{A function that simulates data for a given parameter
value. The first argument should be the parameters. Other necessary
arguments (optional) can be specified with \code{simArgs}.}

\item{fnSimVec}{A vectorised function that simulates a number of
datasets simultaneously for a given parameter value. The first two
arguments should be the number of simulations to run and parameters,
respectively. Other necessary arguments (optional) can be specified with
\code{simArgs}. The output must be a list of each simulation result or a
matrix with each row corresponding to a simulation.}

\item{fnSum}{A function for computing summary statistics of data. The
first argument should be the observed or simulated dataset. Other necessary
arguments (optional) can be specified with \code{sumArgs}.}

\item{fnLogPrior}{A function that computes the log of prior density for a
parameter. If this is missing, the prior by default is an improper flat
prior over the real line for each parameter. The function must have a
single input: a vector of parameter values.}

\item{simArgs}{A list of additional arguments to pass into the simulation
function. Only use when the input \code{fnSim} requires additional
arguments.}

\item{sumArgs}{A list of additional arguments to pass into the summary
statistics function. Only use when the input \code{fnSum} requires
additional arguments.}

\item{theta0}{Initial guess of the parameter value.}

\item{thetaNames}{A string vector of parameter names, which must have the
same length as the parameter vector.}

\item{test}{Logical, whether a short simulation test will be ran
upon initialisation.}

\item{verbose}{Logical, whether to print verbose messages when
initialising a ``MODEL'' object.}

\item{model}{A ``MODEL'' class object.}

\item{n}{The number of simulations to run.}

\item{theta}{The parameter value.}

\item{summStat}{Logical indicator whether the correpsonding summary statistics
should be returned or not. The default is \code{TRUE}.}

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

\item{seed}{A seed number to pass to the \code{set.seed} function. The
default is \code{NULL}, when no seed number is specified. Please note
\code{parallel} also affects the result even with the same seed.}

\item{x}{The data to pass to the summary statistics function.}
}
\value{
A list of simulation results using the given parameter. \code{x}
  contains the raw simulated datasets. \code{ssx} contains the summary
  statistics.

A vector of the summary statistics.
}
\description{
The S4 class contains the simulation and summary statistics
  function and other necessary arguments for a model to run in the main
  \code{bsl} function.

\code{newModel} is the constructor function for a \code{MODEL}
  object.

\code{simulation} runs a number of simulations and computes the
  correponding summary statistics with the provided model.

\code{summStat} computes the summary statistics with the given data and model object.
The summary statistics function and relevant arguments are obtained from the model.
}
\section{Slots}{

\describe{
\item{\code{fnSim}}{A function that simulates data for a given parameter value. The
first argument should be the parameters. Other necessary arguments
(optional) can be specified with \code{simArgs}.}

\item{\code{fnSimVec}}{A vectorised function that simulates a number of datasets
simultaneously for a given parameter value. If this is not \code{NULL},
vectorised simulation function will be used instead of \code{fnSim}. The
first two arguments should be the number of simulations to run and
parameters, respectively. Other necessary arguments (optional) can be
specified with \code{simArgs}. The output must be a list of each simulation
result.}

\item{\code{fnSum}}{A function for computing summary statistics of data. The first
argument should be the observed or simulated dataset. Other necessary
arguments (optional) can be specified with \code{sumArgs}. The users should
code this function carefully so the output have fixed length and never
contain any \code{Inf} value.}

\item{\code{fnLogPrior}}{A function that computes the log of prior density for a
parameter. The default is \code{NULL}, which uses an improper flat prior
over the real line for each parameter. The function must have a single
input: a vector of parameter values.}

\item{\code{simArgs}}{A list of additional arguments to pass into the simulation
function. Only use when the input \code{fnSim} or \code{fnSimVec} requires
additional arguments. The default is \code{NULL}.}

\item{\code{sumArgs}}{A list of additional arguments to pass into the summary
statistics function. Only use when the input \code{fnSum} requires
additional arguments. The default is \code{NULL}.}

\item{\code{theta0}}{Initial guess of the parameter value, which is used as the
starting value for MCMC.}

\item{\code{thetaNames}}{Expression, parameter names.}

\item{\code{ns}}{The number of summary statistics of a single observation. Note this
will be generated automatically, thus is not required for initialisation.}

\item{\code{test}}{Logical, whether a short simulation test will be ran upon
initialisation.}

\item{\code{verbose}}{Logical, whether to print verbose messages when initialising a
``MODEL'' object.}
}}

\examples{
# set up the model for the ma2 example
data(ma2)
m <- newModel(fnSim = ma2_sim, fnSum = ma2_sum, simArgs = ma2$sim_args,
                  theta0 = ma2$start, fnLogPrior = ma2_prior, verbose = FALSE)
validObject(m)

# benchmark the serial and vectorised simulation function (require the rbenchmark package)
m1 <- newModel(fnSim = ma2_sim, fnSum = ma2_sum, simArgs = ma2$sim_args,
            theta0 = ma2$start, fnLogPrior = ma2_prior)
m2 <- newModel(fnSimVec = ma2_sim_vec, fnSum = ma2_sum, simArgs = ma2$sim_args,
            theta0 = ma2$start, fnLogPrior = ma2_prior)
require("rbenchmark")
\dontshow{
benchmark(serial  = simulation(m1, n = 50, theta = c(0.6, 0.2)),
          vectorised  = simulation(m2, n = 50, theta = c(0.6, 0.2)))
}
\dontrun{
benchmark(serial  = simulation(m1, n = 1000, theta = c(0.6, 0.2)),
          vectorised  = simulation(m2, n = 1000, theta = c(0.6, 0.2)))
}

}
\Rdversion{1.1}

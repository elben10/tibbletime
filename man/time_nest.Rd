% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/time_nest.R
\name{time_nest}
\alias{time_nest}
\title{Nest a \code{tbl_time} to a specified time period}
\usage{
time_nest(data, period = "yearly", ..., .key = "data")
}
\arguments{
\item{data}{A \code{tbl_time} object.}

\item{period}{The period to nest to.}

\item{...}{Used to specify columns you do not want in the nest. Specified
as \code{-col_name}.}

\item{.key}{The name of the new column, as a string or symbol.

This argument is passed by expression and supports
\link[rlang:quasiquotation]{quasiquotation} (you can unquote strings
and symbols). The name is captured from the expression with
\code{\link[rlang:quo_name]{rlang::quo_name()}} (note that this kind of interface where
symbols do not represent actual objects is now discouraged in the
tidyverse; we support it here for backward compatibility).}
}
\description{
\code{time_nest} allows for quick nesting of \code{tbl_time} objects by period so that
manipulation can be performed on each period's data set individually. See
\code{\link[tidyr:nest]{tidyr::nest()}} for information on nesting generally.
}
\details{
As an example, nesting by a \code{"yearly"} period will return a \code{tbl_time} object
with a date column containing the dates at the end of each year, and a
list-column of smaller \code{tbl_time} objects containing all of the data for
that year.

Because it is likely the case that the original dates will be required
inside the nested \code{tbl_time} objects for further manipulation,
the original dates are kept as a \code{.date} column in each \code{tbl_time} object in
the list-column.

This function respects \code{\link[dplyr:group_by]{dplyr::group_by()}} groups.
}
\note{
The following periods are available:
\itemize{
\item \code{"yearly"}
\item \code{"quarterly"}
\item \code{"monthly"}
\item \code{"weekly"}
\item \code{"daily"}
\item \code{"hour"}
\item \code{"minute"}
\item \code{"second"}
}
}
\examples{

# Basic functionality -------------------------------------------------------

data(FB)
FB <- as_tbl_time(FB, date)

# Nest yearly
time_nest(FB, "yearly")

# Nest yearly, but don't drag symbol into the nest
time_nest(FB, "yearly", -symbol)

# Nest quarterly
time_nest(FB, "quarterly")

# Grouped functionality -----------------------------------------------------

data(FANG)
FANG <- as_tbl_time(FANG, date) \%>\%
  group_by(symbol)

# Nest yearly, but by group
FANG \%>\%
  time_nest("yearly")

}

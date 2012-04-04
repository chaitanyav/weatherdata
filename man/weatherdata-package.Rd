\name{weatherdata-package}
\alias{weatherdata-package}
\alias{weatherdata}
\docType{package}
\title{
weatherdata\cr
package for extracting pws historical data using wunderground API
}
\description{
This package can be used to get the pws based on (latitude, longitude),
(State, City) and (Country, City) within certain distance. There are methods to extract subtables
from the pws data table based on distance, state, city. Historical data for
all the pws can be pulled out based on a given start time, end time. Weather
conditions can be plotted across all pws. Also, plots to see how condition vs
condition for a given pws
}
\details{
\tabular{ll}{
Package: \tab weatherdata\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2012-03-03\cr
License: \tab GPL-2\cr
LazyLoad: \tab yes\cr
}
}
\author{
NagaChaitanya Vellanki <me@chaitanyavellanki.com>
}
\seealso{
\code{\linkS4class{wunderGround}}
\code{\link{pwsVisualization}}
}
\references{
Documentation for wunderground API
http://www.wunderground.com/weather/api/d/documentation.html

Field descriptions of PWS data
http://www.wunderground.com/weather/api/d/documentation.html#fields
}

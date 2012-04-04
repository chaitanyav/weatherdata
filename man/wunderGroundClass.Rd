\name{wunderGround}
\docType{class}
\alias{wunderGround-class}
\alias{wunderGround}
\alias{new,wunderGround-method}
\alias{pwsByLatLong,wunderGround-method}
\alias{pwsByCountryCity,wunderGround-method}
\alias{pwsByStateCity,wunderGround-method}
\alias{subtableByStateCityDistance,wunderGround-method}
\alias{pwsHistoricalData,wunderGround-method}
\alias{makeRequest}
\alias{parsePWSDataXML}
\alias{parsePWSHistoricalData}
\alias{getPWSData}
\alias{pwsByLatLong}
\alias{pwsByCountryCity}
\alias{pwsByStateCity}
\alias{subtableByStateCityDistance}
\alias{pwsHistoricalData}


\title{Class "wunderGround"}
\description{Objects for accessing pws data, pws historical data using the
wunderground API }
\section{creating objects of wunderGroundClass, querying the PWS, historical PWS Data}{
objects can be created using the new method

 \code{new("wunderGround", state="CA",city="Fremont", distance=5)}\cr
 \code{new("wunderGround", latitude=37.776289,longitude =-122.395234)}\cr
 \code{new("wunderGround", country="France", city="Paris")}\cr

Note: latitude, longitude, distance are numeric. Also, the distance is an
optional field. If distance is not specified the pws data frame will contain
all available pws from wunderground.

If the city has multiple words in it use _ to separate them. For e.g.
San_Francisco, Los_Angeles, Santa_Clara

Also, you can also specify the developer key for accessing the wunderground
data through the API.The default developer key used here can do a 10 queries per minute
new developer key can be specified using key slot

To query the PWS:\cr
using state, city\cr
\code{obj <- new("wunderGround", state="CA",city="Santa_Clara")}\cr
\code{obj <- pwsByStateCity(obj)}\cr

using country, city\cr
\code{obj <- new("wunderGround", country="France",city="Paris",distance=5)}\cr
\code{obj <- pwsByCountryCity(obj)}\cr

using latitude, longitude\cr
\code{obj <- new("wunderGround", latitude=37.776289,longitude=-122.395234)}\cr
\code{obj <- pwsByLatLong(obj)}\cr

The returned object is of type wunderGround and has the PWS data in the pws
slot of the object\cr

Querying historical data:\cr
\code{obj <- new("wunderGround", state="CA",city="Santa_Clara")}\cr
\code{obj <- pwsByStateCity(obj)}\cr
\code{pwsHistoricalData(obj, startTime=Sys.time() - (3 * 60 *60),endTime=Sys.time())}\cr

pwsHistoricaldata returns a data frame containing the conditions for all pws
in obj@pws
}

\usage{
  # returns a new object with pws data queried using state city
  \S4method{pwsByStateCity}{wunderGround}(object)

  # returns a new object with pws data queried using lat, long
  \S4method{pwsByLatLong}{wunderGround}(object)

  # returns a new object with pws data queried using country,
  # city
  \S4method{pwsByCountryCity}{wunderGround}(object)

  #returns a data frame with pws data filtered by state, city and distance
  \S4method{subtableByStateCityDistance}{wunderGround}(object,filterState,filterCity,distance)

  #returns a data frame with pws historical data
  \S4method{pwsHistoricalData}{wunderGround}(object,startTime, endTime)
}

\arguments{
  \item{object}{ wunderGround object }
  \item{filterState}{character string e.g. "CA", "UT"}
  \item{filterCity}{character string e.g. "Moab", "Tahoe","San_Fransisco"}
  \item{distance}{a numeric object e.g. 5, 6}
  \item{startTime}{ is an object of class POSIXt or POSIXct }
  \item{endTime}{ is an object of class POSIXt or POSIXct }
}
\examples{
\donttest{obj <- new("wunderGround",state="CA",city="Santa_Clara",distance=5)}
\donttest{obj <- pwsByStateCity(obj)}
\donttest{head(obj@pws)}

\donttest{obj <- new("wunderGround", latitude=37.776289,longitude=-122.395234)}
\donttest{obj <- pwsByLatLong(obj)}
\donttest{head(obj@pws)}

\donttest{obj <- new("wunderGround", country="France",city="Paris",distance=5)}
\donttest{obj <- pwsByCountryCity(obj)}
\donttest{head(obj@pws)}

\donttest{obj <- new("wunderGround", state="CA",city="Santa_Clara")}
\donttest{obj <- pwsByStateCity(obj)}
\donttest{subtab <- subtableByStateCityDistance(obj, distance=5)}
\donttest{head(subtab)}

\donttest{subtab <- subtableByStateCityDistance(obj, filterCity="Santa Clara")}
\donttest{head(subtab)}
\donttest{tab <- pwsHistoricalData(obj, startTime=Sys.time() - (2 * 60 * 60),endTime=Sys.time())}
\donttest{head(tab)}
\donttest{tail(tab)}
}

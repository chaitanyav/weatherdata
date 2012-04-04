\name{pwsVisualization}
\alias{pwsVisualization}
\alias{fieldDescriptions}
\alias{plotConditionAcrossAllPWS}
\alias{plotConditionsForPWS}


\title{PWS Visualization}
\description{Methods to plot the PWS historical data}

\usage{
  #returns the field descriptions of the PWS historical data
  fieldDescriptions()

  #plot a condition(field) across all PWS
  # This is useful since some of the PWS contain invalid data, we
  # can easily identify those PWS and clean the data
  plotConditionAcrossAllPWS(historicalData, condition)

  #plot condition vs condition for a pws
  plotConditionsForPWS(historicalData, xcondition, ycondition, pws)
}

\arguments{
  \item{historicalData}{data frame containing the PWS data for a given startTime, endTime. See wunderGround class}
  \item{xcondition}{ character string, column name in the data frame,used in the plot for x-axis }
  \item{ycondition}{ character string, column name in the data frame,used in the plot for y-axis }
  \item{pws}{character string, name of the personal weather station to be filtered from the historical data }
  \item{condition}{character string, column name in the data frame to be plotted across all pws}
}

\examples{
\donttest{obj <- new("wunderGround", state="CA",city="Santa_Clara")}
\donttest{obj <- pwsByStateCity(obj)}
\donttest{tab <- pwsHistoricalData(obj, startTime=Sys.time() - (60 * 60),endTime=Sys.time())}
\donttest{head(tab)}
\donttest{fieldDescriptions()}
\donttest{plotConditionAcrossAllPWS(historicalData=tab, condition="tempi")}
\donttest{plotConditionAcrossAllPWS(historicalData=tab, condition="dewptm")}
\donttest{plotConditionsForPWS(historicalData=tab,xcondition="tempm",ycondition="dewptm", pws="KCASANTA87")}
\donttest{plotConditionsForPWS(historicalData=tab, ycondition="tempi",xcondition="observationTime", pws="KCASANTA87")}
}

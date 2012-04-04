fieldDescriptions <- function() {
 descriptionByField <- list()

descriptionByField[["tempm"]] <- "Temp in C"
descriptionByField[["tempi"]] <- "Temp in F"
descriptionByField[["dewptm"]] <- "Dewpoint in C"
descriptionByField[["dewpti"]] <- "Duepoint in F"
descriptionByField[["hum"]] <- "Humidity %"
descriptionByField[["wspdm"]] <- "WindSpeed kph"
descriptionByField[["wspdi"]] <- "Windspeed in mph"
descriptionByField[["wgustm"]] <- "Wind gust in kph"
descriptionByField[["wgusti"]] <- "Wind gust in mph"
descriptionByField[["wdird"]] <- "Wind direction in degrees"
descriptionByField[["wdire"]] <- "Wind direction description (ie, SW, NNE )"
descriptionByField[["vism"]] <- "Visibility in Km"
descriptionByField[["visi"]] <- "Visability in Miles"
descriptionByField[["pressurem"]] <- "Pressure in mBar"
descriptionByField[["pressurei"]] <- "Pressure in inHg"
descriptionByField[["windchillm"]] <- "Wind chill in C"
descriptionByField[["windchilli"]] <- "Wind chill in F"
descriptionByField[["heatindexm"]] <- "Heat index C"
descriptionByField[["heatindexi"]] <- "Heat Index F"
descriptionByField[["precipm"]] <- "Precipitation in mm"
descriptionByField[["precipi"]] <- "Precipitation in inches"
descriptionByField[["pop"]] <- "Probability of Precipitation"
descriptionByField[["observationTime"]] <- "local time at which measurement was taken"
descriptionByField[["pws"]] <- "personal weather station"
descriptionByField[["conds"]] <- "See possible condition phrases below"

return(descriptionByField)
}

plotConditionAcrossAllPWS <- function(historicalData, condition) {
  if((condition %in% names(historicalData))) {
    descriptionByField <- fieldDescriptions()
    ggplot(historicalData, aes_string(y=condition, x="pws")) +
    geom_boxplot(outlier.colour="red", outlier.size=4,
    outlier.shape=1)  +
    opts(axis.text.x=theme_text(angle=-90, hjust=0)) +
    ylab(paste(condition, " (",descriptionByField[[condition]], ")", sep="")) +
    xlab(paste("pws", " (",descriptionByField[["pws"]], ")", sep=""))
  }
  else {
    stop("condition is not a column of the PWS historical data")
  }

}

plotConditionsForPWS <- function(historicalData, xcondition,
    ycondition, pws) {

    pwsNames <- unique(historicalData$pws)
      if(!(pws %in% pwsNames)) {
        stop("specified pws does not exist in the historical data")
      }

    if((xcondition %in% names(historicalData)) && (ycondition %in%
          names(historicalData))) {

    descriptionByField <- fieldDescriptions()

    p <- ggplot(subset(historicalData, pws == pws), aes_string(y=ycondition, x=xcondition)) +
    geom_point(colour= "blue", shape=1) +
    xlab(paste(xcondition, " (", descriptionByField[[xcondition]],")",sep="")) +
    ylab(paste(ycondition, " (", descriptionByField[[ycondition]], ")", sep=""))

    chart_title <- paste(xcondition, " vs ", ycondition, " for ", pws, sep="")

    if(xcondition == "observationTime") {
     p + opts(axis.text.x=theme_text(angle=-90, hjust=0), title=chart_title)
    }
    else {
      p + opts(title= chart_title)
    }

    }
    else {
      stop("xcondition, ycondition should be columns of historical data")
    }
}

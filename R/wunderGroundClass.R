setClass("wunderGround", representation(key="character", pws="data.frame",
latitude="numeric", longitude="numeric", city="character",
country="character", distance="numeric", state="character"), prototype=prototype(key="c77ecd677f076d5a",
pws=data.frame()))

setGeneric(name="pwsByLatLong",
def=function(object){standardGeneric("pwsByLatLong")})

setMethod(f="pwsByLatLong", signature="wunderGround", definition=function(object) {
  if(is(object, "wunderGround")) {

  if((length(object@latitude) == 0) || (length(object@longitude) == 0)) {
  stop('latitude, longitude were not provided for this object')
  }

  apiUrl <- paste("http://api.wunderground.com/api/", object@key,
  "/geolookup/q/", as.character(object@latitude), ",",
  as.character(object@longitude), ".xml", sep = "")

  print(paste("Fetching PWS with apiurl ", apiUrl, sep=""))
  object@pws <- getPWSData(apiUrl, object)
  return(object)
}
else {
  stop(gettextf('supplied object must be a wunderGround, got class "%s"',
  class(object)))
}
})

setGeneric(name="pwsByCountryCity",
def=function(object){standardGeneric("pwsByCountryCity")})

setMethod(f="pwsByCountryCity", signature="wunderGround",
    definition=function(object){

  if(is(object, "wunderGround")) {

  if((length(object@country) == 0) || (length(object@city) == 0)) {
  stop('country, city were not provided for this object')
  }

  apiUrl <- paste("http://api.wunderground.com/api/", object@key,
  "/geolookup/q/", object@country, "/", object@city, ".xml", sep = "")

  print(paste("Fetching PWS with apiurl ", apiUrl, sep=""))

  object@pws <- getPWSData(apiUrl, object)
  return(object)
}
else {
  stop(gettextf('supplied object must be a wunderGround, got class "%s"',
  class(object)))
}

})

setGeneric(name="pwsByStateCity",
def=function(object){standardGeneric("pwsByStateCity")})

setMethod(f="pwsByStateCity", signature="wunderGround",
    definition=function(object){

  if(is(object, "wunderGround")) {

  if((length(object@state) == 0) || (length(object@city) == 0)) {
  stop('state, city were not provided for this object')
  }

  apiUrl <- paste("http://api.wunderground.com/api/", object@key,
  "/geolookup/q/", object@state, "/", object@city, ".xml", sep = "")

  print(paste("Fetching PWS with apiurl ", apiUrl, sep=""))

  object@pws <- getPWSData(apiUrl, object)
  return(object)
}
else {
  stop(gettextf('supplied object must be a wunderGround, got class "%s"',
  class(object)))
}

})

setGeneric(name="subtableByStateCityDistance",
def=function(object, filterState = NULL, filterCity = NULL, distance =
0){standardGeneric("subtableByStateCityDistance")})

setMethod(f="subtableByStateCityDistance", signature="wunderGround",
    definition=function(object, filterState, filterCity, distance = 0){

  if(is(object, "wunderGround")) {

  subtab <- object@pws

  if(length(filterState) != 0) {
    print("Filtering by state")
    subtab <- subset(object@pws, state == filterState)
  }

  if(length(filterCity) != 0) {
    print("Filtering by city")
    subtab <- subset(object@pws, city == filterCity)
  }

  if(distance > 0) {
    print("Filtering by distance")
  subtab <- subset(object@pws, distance_mi <= distance)
  }

    return(subtab)
}
else {
  stop(gettextf('supplied object must be a wunderGround, got class "%s"',
  class(object)))
}

})

setGeneric(name="pwsHistoricalData",
def=function(object, startTime, endTime){standardGeneric("pwsHistoricalData")})

setMethod(f="pwsHistoricalData", signature="wunderGround",
    definition=function(object, startTime, endTime){

  if(is(object, "wunderGround")) {

  if((length(startTime) == 0) || (length(endTime) == 0)) {
  stop('startTime, endTime were not provided')
  }
  else {
    if(!is(startTime, "POSIXt") || !is(startTime, "POSIXct")) {
    stop("Invalid startTime, should be an object of class POSIXt or POSIXct")
    }

    if(!is(endTime, "POSIXt") || !is(endTime, "POSIXct")) {
    stop("Invalid endTime, should be an object of class POSIXt or POSIXct")
    }


  historicalData <- NULL

  utcStartTime <- as.POSIXlt(startTime, tz="UTC")
  utcEndTime <- as.POSIXlt(endTime, tz= "UTC")

  for(pws in object@pws$id) {

  startDate <- as.Date(startTime, tz="")
  endDate <- as.Date(endTime, tz="")

  while(startDate <= endDate) {
    apiUrl <- paste("http://api.wunderground.com/api/", object@key,
        "/history_", format(startDate, "%Y%m%d"), "/q/pws:", pws, ".xml", sep = "")

    print(paste("Fetching data for pws: ", pws, " for " , startDate, " with apiurl ",
    apiUrl, sep=""))
      xmlText <- makeRequest(apiUrl)
      temp <- parsePWSHistoricalData(xmlText, pws, utcStartTime, utcEndTime)
      if(length(historicalData) == 0) {
        historicalData <- temp
      }
      else {
      historicalData <- rbind(temp, historicalData)
      }
      startDate <- startDate + 1
  }
  }
}
  return(historicalData)
}
else {
  stop(gettextf('supplied object must be a wunderGround, got class "%s"',
  class(object)))
}

})

makeRequest <- function(apiUrl) {
  con <- url(apiUrl)
  xmlText <- readLines(con)
  close(con)

  return(xmlText)
}

getPWSData <- function(apiUrl, object) {

  xmlText <- makeRequest(apiUrl)
  object@pws <- parsePWSDataXML(xmlText)

  if((length(object@distance) != 0)) {
    tab <- object@pws
    object@pws <- subset(tab, tab["distance_mi"] <= object@distance)
  }

  return(object@pws)
}

parsePWSDataXML <- function(xmlText) {
  row <- 0
  pws = data.frame(neighborhood = character(),
  city = character(),
  state = character(),
  country = character(),
  id= character(),
  distance_km = numeric(),
  distance_mi = numeric(),
  stringsAsFactors = FALSE)

  doc = xmlTreeParse(xmlText, asText = TRUE, useInternalNodes = TRUE,
      handlers= list("pws" = function(node){
        stationNodes = xmlChildren(node)
        for(stationNode in stationNodes) {
        stationAttributes = list()
        for(stationAttributeNode in xmlChildren(stationNode)) {
          name = xmlName(stationAttributeNode)
          value = xmlValue(stationAttributeNode)
          stationAttributes[[name]] = value
        }

        row <<- row + 1
        stationAttributes[["distance_mi"]] <-
        as.numeric(stationAttributes[["distance_mi"]])
        stationAttributes[["distance_km"]] <-
        as.numeric(stationAttributes[["distance_km"]])
        pws[row,] <<- stationAttributes
        }
        }))

  return(pws)
}

parsePWSHistoricalData <- function(xmlText, pws, utcStartTime, utcEndTime) {
  historicalData = data.frame(tempm = numeric(),
  tempi = numeric(),
  dewptm = numeric(),
  dewpti = numeric(),
  hum = numeric(),
  wspdm = numeric(),
  wspdi = numeric(),
  wgustm = numeric(),
  wgusti = numeric(),
  wdird = numeric(),
  wdire = character(),
  pressurem = numeric(),
  pressurei = numeric(),
  windchillm = numeric(),
  windchilli = numeric(),
  heatindexm = numeric(),
  heatindexi = numeric(),
  precip_ratem = numeric(),
  precip_ratei = numeric(),
  precip_totalm = numeric(),
  precip_totali = numeric(),
  observationTime = character(),
  pws = character(),
  stringsAsFactors = FALSE)

  row <- 0
  doc = xmlTreeParse(xmlText, asText = TRUE, useInternalNodes = TRUE, handlers
      = list("observations" = function(node){
          observationNodes = xmlChildren(node)
          for(observationNode in observationNodes) {
            dateNode = observationNode[["utcdate"]]
            year = xmlValue(dateNode[["year"]])
            month = xmlValue(dateNode[["mon"]])
            day = xmlValue(dateNode[["mday"]])
            hour = xmlValue(dateNode[["hour"]])
            min = xmlValue(dateNode[["min"]])
            tz = xmlValue(dateNode[["tzname"]])

            observationTime = ISOdatetime(year = year, month = month, day =
            day, hour = hour, min = min, sec="0", tz = tz)

              if(!(is.na(observationTime)) && (observationTime >= utcStartTime) && (observationTime <=
              utcEndTime)) {
            observationAttributes = list()
            for(observationAttributeNode in xmlChildren(observationNode)) {
              name = xmlName(observationAttributeNode)
              value = xmlValue(observationAttributeNode)
              if(!(name %in% c("date", "utcdate", "softwaretype", "UV",
              "solarradiation"))) {
                if(name != "wdire") {
                    observationAttributes[[name]] = as.numeric(value)
                }
                else {
                    observationAttributes[[name]] = value
                }
              }
            }

            observationAttributes[["observationTime"]] <-
            format(observationTime, tz="", usetz=TRUE)
            observationAttributes[["pws"]] <- pws
            row <<- row + 1
            historicalData[row,] <<- observationAttributes
          }
        }
        }))

  historicalData
}

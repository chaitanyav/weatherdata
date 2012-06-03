# Weather Data
  R interface to access the PWS data through the Wunderground API(http://www.wunderground.com/weather/api/d/documentation.html)

## To build the package
  ~~~
    R CMD build weatherdata
  ~~~
## To check the package
  ~~~
    R CMD check weatherdata_1.0.tar.gz
  ~~~
## To install the package
  ~~~
    R CMD install weatherdata_1.0.tar.gz
  ~~~
## To run the examples of wunderGround class and pwsVisualization
  ~~~
    require('weatherdata')
    example(wunderGround)
    example(pwsVisualization)
  ~~~
## Documentation
  ~~~
    Class "wunderGround"

    Description

    Objects for accessing pws data, pws historical data using the wunderground API

    Usage

      # returns a new object with pws data queried using state city
      ## S4 method for signature 'wunderGround'
    pwsByStateCity(object)

      # returns a new object with pws data queried using lat, long
      ## S4 method for signature 'wunderGround'
    pwsByLatLong(object)

      # returns a new object with pws data queried using country,
      # city
      ## S4 method for signature 'wunderGround'
    pwsByCountryCity(object)

      #returns a data frame with pws data filtered by state, city and distance
      ## S4 method for signature 'wunderGround'
    subtableByStateCityDistance(object,filterState,filterCity,distance)

      #returns a data frame with pws historical data
      ## S4 method for signature 'wunderGround'
    pwsHistoricalData(object,startTime, endTime)
    Arguments

    object   wunderGround object
    filterState      character string e.g. "CA", "UT"
    filterCity       character string e.g. "Moab", "Tahoe","San_Fransisco"
    distance         a numeric object e.g. 5, 6
    startTime        is an object of class POSIXt or POSIXct
    endTime  is an object of class POSIXt or POSIXct
    creating objects of wunderGroundClass, querying the PWS, historical PWS Data

    objects can be created using the new method

    new("wunderGround", state="CA",city="Fremont", distance=5)
    new("wunderGround", latitude=37.776289,longitude =-122.395234)
    new("wunderGround", country="France", city="Paris")
    Note: latitude, longitude, distance are numeric. Also, the distance is an optional field. If distance is not specified the pws data frame will contain all available pws from wunderground.

    If the city has multiple words in it use _ to separate them. For e.g. San_Francisco, Los_Angeles, Santa_Clara

    Also, you can also specify the developer key for accessing the wunderground data through the API.The default developer key used here can do a 10 queries per minute new developer key can be specified using key slot

    To query the PWS:
    using state, city
    obj <- new("wunderGround", state="CA",city="Santa_Clara")
    obj <- pwsByStateCity(obj)
    using country, city
    obj <- new("wunderGround", country="France",city="Paris",distance=5)
    obj <- pwsByCountryCity(obj)
    using latitude, longitude
    obj <- new("wunderGround", latitude=37.776289,longitude=-122.395234)
    obj <- pwsByLatLong(obj)
    The returned object is of type wunderGround and has the PWS data in the pws slot of the object
    Querying historical data:
    obj <- new("wunderGround", state="CA",city="Santa_Clara")
    obj <- pwsByStateCity(obj)
    pwsHistoricalData(obj, startTime=Sys.time() - (3 * 60 *60),endTime=Sys.time())
    pwsHistoricaldata returns a data frame containing the conditions for all pws in obj@pws

    Examples

    obj <- new("wunderGround",state="CA",city="Santa_Clara",distance=5)
    obj <- pwsByStateCity(obj)
    head(obj@pws)

    obj <- new("wunderGround", latitude=37.776289,longitude=-122.395234)
    obj <- pwsByLatLong(obj)
    head(obj@pws)

    obj <- new("wunderGround", country="France",city="Paris",distance=5)
    obj <- pwsByCountryCity(obj)
    head(obj@pws)

    obj <- new("wunderGround", state="CA",city="Santa_Clara")
    obj <- pwsByStateCity(obj)
    subtab <- subtableByStateCityDistance(obj, distance=5)
    head(subtab)

    subtab <- subtableByStateCityDistance(obj, filterCity="Santa Clara")
    head(subtab)
    tab <- pwsHistoricalData(obj, startTime=Sys.time() - (2 * 60 * 60),endTime=Sys.time())
    head(tab)
    tail(tab)
  ~~~

***
  ~~~
    PWS Visualization

    Description

    Methods to plot the PWS historical data

    Usage

      #returns the field descriptions of the PWS historical data
      fieldDescriptions()

      #plot a condition(field) across all PWS
      # This is useful since some of the PWS contain invalid data, we
      # can easily identify those PWS and clean the data
      plotConditionAcrossAllPWS(historicalData, condition)

      #plot condition vs condition for a pws
      plotConditionsForPWS(historicalData, xcondition, ycondition, pws)
    Arguments

    historicalData   data frame containing the PWS data for a given startTime, endTime. See wunderGround class
    xcondition       character string, column name in the data frame,used in the plot for x-axis
    ycondition       character string, column name in the data frame,used in the plot for y-axis
    pws      character string, name of the personal weather station to be filtered from the historical data
    condition        character string, column name in the data frame to be plotted across all pws
    Examples

    obj <- new("wunderGround", state="CA",city="Santa_Clara")
    obj <- pwsByStateCity(obj)
    tab <- pwsHistoricalData(obj, startTime=Sys.time() - (60 * 60),endTime=Sys.time())
    head(tab)
    fieldDescriptions()
    plotConditionAcrossAllPWS(historicalData=tab, condition="tempi")
    plotConditionAcrossAllPWS(historicalData=tab, condition="dewptm")
    plotConditionsForPWS(historicalData=tab,xcondition="tempm",ycondition="dewptm", pws="KCASANTA87")
    plotConditionsForPWS(historicalData=tab, ycondition="tempi",xcondition="observationTime", pws="KCASANTA87")
  ~~~

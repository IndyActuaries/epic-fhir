#' ### CODE OWNERS: Shea Parkes
#' 
#' ### OBJECTIVE:
#'   * Deployment of ShinyApp
#' 
#' ### DEVELOPER NOTES:
#'   * None

library(rsconnect)

#' ### LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE

rsconnect::deployApp(
  appDir=getwd()
  ,appName='shinyapp-fhir'
  )

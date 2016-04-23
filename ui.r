#' ### CODE OWNERS: Shea Parkes
#' 
#' ### OBJECTIVE:
#'   * UI side of Epic FHIR Shiny App.
#' 
#' ### DEVELOPER NOTES:
#'   * None

require(shiny)

#' ### LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE

shinyUI(fluidPage(
  
  titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

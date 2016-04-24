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
  
  titlePanel("Demonstrating the value of INPC"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput('ui_name')
      ,h4('Patient DOB')
      ,textOutput('patient_dob')
      ,h4('Patient Address')
      ,textOutput('patient_address')
      ,uiOutput('ui_loinc')
      ,sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
    
    mainPanel(
      tabsetPanel(
       tabPanel('OldFaith', plotOutput("distPlot"))
       ,tabPanel('Labs', dataTableOutput("labsTable"))
      )
    )
  )
))

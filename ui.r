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
      ,p()
      ,h4('Patient Info')
      ,textOutput('patient_dob')
      ,textOutput('patient_address')
      ,p()
      ,uiOutput('ui_loinc')
      ,uiOutput('ui_fhir')
    ),
    
    mainPanel(
      tabsetPanel(
       tabPanel('OldFaith', plotOutput("distPlot"))
       ,tabPanel('Data Table', dataTableOutput("labsTable"))
      )
    )
  )
))

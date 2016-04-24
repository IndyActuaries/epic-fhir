#' ### CODE OWNERS: Shea Parkes, Kyle Baird
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
      tabsetPanel(
        tabPanel(
          'FHIR Data'
          ,uiOutput('ui_name')
          ,p()
          ,h4('Patient Info')
          ,textOutput('patient_dob')
          ,textOutput('patient_address')
          ,p()
          ,uiOutput('ui_loinc')
          ,uiOutput('ui_fhir')
          #,verbatimTextOutput("trace_fhir")
        )
        ,tabPanel(
          'Model Params'
          ,numericInput("scale_input", label = h3("CTS Scale"), value = 1)
          ,numericInput("order_input", label = h3("CTS Order"), value = 1)
        )
      )
    ),
    
    mainPanel(
      tabsetPanel(
       tabPanel('OldFaith', plotOutput("distPlot"))
       ,tabPanel('Data Table', dataTableOutput("labsTable"))
      )
    )
  )
))

#' ### CODE OWNERS: Shea Parkes
#'
#' ### OBJECTIVE:
#'   * Server side code of Epic FHIR Shiny App.
#'
#' ### DEVELOPER NOTES:
#'   * None

require(shiny)

source('r/load_data.r', chdir=TRUE)

#' ### LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$labsTable <- renderDataTable(df.labs)
  
})

#' ### CODE OWNERS: Shea Parkes
#'
#' ### OBJECTIVE:
#'   * Server side code of Epic FHIR Shiny App.
#'
#' ### DEVELOPER NOTES:
#'   * None

require(shiny)
require(dplyr)
require(magrittr)

source('r/load_data.r', chdir=TRUE)

#' ### LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE

freq.name <- df.results %>%
  group_by(name) %>% 
  summarize(n=n()) %>% 
  ungroup()

choices.name <- df.patients %>% 
  inner_join(freq.name) %>% 
  mutate(
    n = ifelse(is.na(n), 0, n)
    ,name.disp = paste0(name, ' (n=', n, ')')
    ) %>%
  arrange(desc(n)) %>% {
    names.decorated <- .$name
    names(names.decorated) <- .$name.disp
    names.decorated
  }

shinyServer(function(input, output) {

  output$ui_name <- renderUI({
    selectInput(
      "select_name"
      ,label="Patient Name"
      ,choices=choices.name
      ,selected=choices.name[1]
      )
  })
  
  output$patient_dob <- renderText({
    df.patients %>%
      filter(name == input$select_name) %>% {
        as.character(.$dob.r)
      }
  })
  
  output$patient_address <- renderText({
    df.patients %>%
      filter(name == input$select_name) %>% {
        ifelse(.$address=='','Unknown',.$address)
      }
  })
  
  output$ui_loinc <- renderUI({
    
    choices.loinc <- freq.loinc %>% 
      filter(name == input$select_name) %>% 
      inner_join(df.labs, by = 'loinc') %>% 
      mutate(
        loinc.disp = paste0(
          loinc
          ,' '
          ,desc
          ,' (n='
          ,n
          ,')'
          )
      ) %>% {
        loinc.decorated <- .$loinc
        names(loinc.decorated) <- .$loinc.disp
        loinc.decorated
      }
    
    selectInput(
      "select_loinc"
      ,label="LOINC Code"
      ,choices=choices.loinc
      ,selected=choices.loinc
    )
  })
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$labsTable <- renderDataTable(df.labs)
  
})

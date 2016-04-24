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
require(tidyr)

source('r/load_data.r', chdir=TRUE)

#' ### LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE

freq.name <- df.results %>%
  group_by(name, fhir) %>% 
  summarize(n=n()) %>% 
  ungroup() %>% 
  spread(fhir, n, fill=0) %>% 
  mutate(n=Epic+INPC)

choices.name <- df.patients %>% 
  inner_join(freq.name) %>% 
  mutate(
    n = ifelse(is.na(n), 0, n)
    ,name.disp = paste0(name, ' (n=', Epic, '; ', INPC, ')')
    ) %>%
  arrange(desc(n)) %>% {
    names.decorated <- .$name
    names(names.decorated) <- .$name.disp
    names.decorated
  }

freq.loinc <- df.results %>%
  group_by(name, loinc, fhir) %>% 
  summarize(n=n()) %>% 
  ungroup() %>% 
  spread(fhir, n, fill=0) %>%
  mutate(n=Epic+INPC)


shinyServer(function(input, output) {

  output$ui_name <- renderUI({
    radioButtons(
      "select_name"
      ,label="Patient Name"
      ,choices=choices.name
      ,selected=choices.name[1]
      )
  })
  
  output$patient_dob <- renderText({
    df.patients %>%
      filter(name == input$select_name) %>% {
        paste('DOB:', as.character(.$dob.r))
      }
  })
  
  output$patient_address <- renderText({
    df.patients %>%
      filter(name == input$select_name) %>% {
        paste('Address:', ifelse(.$address=='','Unknown',.$address))
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
          ,Epic
          ,'; '
          ,INPC
          ,')'
          )
      ) %>% 
      arrange(desc(n)) %>% {
        loinc.decorated <- .$loinc
        names(loinc.decorated) <- .$loinc.disp
        loinc.decorated
      } %>% 
      head(7)
    
    radioButtons(
      "select_loinc"
      ,label="LOINC Code"
      ,choices=choices.loinc
      ,selected=choices.loinc[1]
    )
  })

  output$ui_fhir <- renderUI({
    
    choices.fhir <- freq.loinc %>% 
      filter(
        name == input$select_name
        ,loinc == input$select_loinc
      ) %>% {
          fhir.decor <- c('Epic', 'INPC')
          names(fhir.decor) <- c(
            paste0('Eskenazi (n=', .$Epic, ')')
            ,paste0('INPC (n=', .$INPC, ')')
          )
        }
    
    checkboxGroupInput(
      "select_fhir"
      ,label="FHIR Source"
      ,choices=choices.fhir
      ,selected=choices.fhir
    )
  })
  
    
  output$distPlot <- renderPlot({
    hist(rnorm(50))
  })
  
  output$labsTable <- renderDataTable({
    df.results %>% 
      filter(
        input$select_name == name
        ,input$select_loinc == loinc
      ) %>% 
      arrange(date.r)
  })
  
})

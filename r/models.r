#' ## Code Owners: Kyle Baird, Shea Parkes
#' ### OWNERS ATTEST TO THE FOLLOWING:
#'   * The `master` branch will meet Milliman QRM standards at all times.
#'   * Deliveries will only be made from code in the `master` branch.
#'   * Review/Collaboration notes will be captured in Pull Requests (prior to merging).
#' 
#' 
#' ### Objective:
#'   * Fit time series models to show trends in patient lab results
#' 
#' ### Developer Notes:
#'   * <none>

require(cts)
require(ggplot2)
require(dplyr)
require(magrittr)

#source("load_data.r")

#' ## LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE



#################
### Basic EDA ###
#################

df.results %>%
  #filter(grepl("A1C", loinc_desc, ignore.case = TRUE)) %>% 
  group_by(name, loinc) %>% 
  #group_by(fhir, loinc, loinc_desc) %>% 
  summarize(n = n()) %>% 
  ungroup() %>% 
  arrange(desc(n))
  #arrange(desc(n)) %>% 
  #head(30) %>% 
  #as.data.frame()

fit_cts <- function(
  patient
  ,code
  ,fhirs
  ,cts.scale
  ,cts.order
  ,result.limit.max
  ,result.limit.min
  ) {

  # patient <- "Argonaut, jessica"; code <- "8480-6"; fhirs <- c('Epic', 'INPC')
  # cts.scale <- 1; cts.order <- 1; result.limit.max<-100000; result.limit.min <- 0
  
  
  data.patient <- df.results %>% 
    filter(
      name == patient
      ,loinc == code
      ,fhir %in% fhirs
      ,result <= result.limit.max
      ,result >= result.limit.min
      )
  
  data.model <- data.patient %>% 
    group_by(date.r) %>% 
    summarize(result = mean(result)) %>% 
    mutate(
      date.float = as.double(date.r) / 60 / 60 / 24
      ) %>% 
    arrange(date.r)
  
  # basic_line_plot <- data.model %>%
  #   ggplot(
  #     aes(x = date.r, y = result)
  #   ) +
  #   geom_line()
  # basic_line_plot

  #################
  ### Model Fit ###
  #################
  
  scale.hint <- 2 * pi / mean(diff(data.model$date.float))

  tryCatch(
    {
      model.munge <- data.frame(
        date.r=data.model$date.r
        ,sser=0
        ,svar=0
      )
      df.pred <- c('None')
      suppressWarnings(ts.model <- car(
        data.model$date.float
        ,data.model$result
        ,scale = cts.scale
        ,order = cts.order
        ,ctrl = car_control(
          trace = TRUE
          ,n.ahead=60
          # ,vri = TRUE
          # ,ccv = "MNCT"
          )
        ))
      model.munge <- data.frame(
        date.r = data.model$date.r
        ,sser = ts.model$sser
        ,svar = ts.model$svar
      )
      #str(ts.model)
      df.pred <- data.frame(
        date.r = as.POSIXct(ts.model$pretime*60*60*24, origin='1970-01-01')
        ,result = ts.model$predict
        ,result_units = 'N/A'
        ,fhir='Prediction'
        ,sser=0
        ,svar=0
      )
    }
    ,error=function(e){print('Caught error')}
    
  )

  

  data.return <- data.patient %>%
    select_(
      "date.r"
      ,"result"
      ,"result_units"
      ,"fhir"
      ) %>% 
    left_join(model.munge, by = "date.r")
  if('data.frame' %in% class(df.pred)){
    data.return <- rbind(data.return, df.pred)
  }
  
  return(data.return)
  }
# test <- fit_cts("Argonaut, jessica", "8480-6")


#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

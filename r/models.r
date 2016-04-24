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
  ) {

  # patient <- "Argonaut, jessica"
  # code <- "8480-6"
  
  data.patient <- df.results %>% 
    filter(name == patient, loinc == code)
  
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

  ts.model <- car(
    data.model$date.float
    ,data.model$result
    ,scale = scale.hint
    ,order = 1
    ,ctrl = car_control(
      trace = TRUE
      # ,vri = TRUE
      # ,ccv = "MNCT"
      )
    )

  model.munge <- data.frame(
    date.r = data.model$date.r
    ,sser = ts.model$sser
    ,svar = ts.model$svar
    )

  data.return <- data.patient %>%
    select_(
      "date.r"
      ,"result"
      ,"fhir"
      ) %>% 
    left_join(model.munge, by = "date.r")
  
  return(data.return)
  }
# test <- fit_cts("Argonaut, jessica", "8480-6")


#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

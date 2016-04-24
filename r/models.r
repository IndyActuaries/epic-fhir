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

data.model <- df.results %>% 
  filter(name == "Argonaut, jessica", loinc == "8480-6") %>% 
  group_by(name, loinc, date.r) %>% 
  summarize(result = mean(result)) %>% 
  mutate(
    date.float = as.double(date.r) / 60 / 60 / 24
    ) %>% 
  arrange(date.r)

basic_line_plot <- data.model %>%
  #filter(name == "Ragsdale, Bacon") %>% 
  ggplot(
    aes(x = date.r, y = result)
  ) +
  geom_line()
basic_line_plot

#################
### Model Fit ###
#################

scale.hint <- 2 * pi / mean(diff(data.model$date.float))
scale.hint

ts.model <- car(
  data.model$date.float
  ,data.model$result
  ,scale = scale.hint
  ,order = 1
  ,ctrl = car_control(
    trace = TRUE
    #,ccv = "MNCT"
    )
  )
ts.model
summary(ts.model)
tsdiag(ts.model)

#needs to return - real date, results, fhir (source), mean (retrospective), stderr (mean)

#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

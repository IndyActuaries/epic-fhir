#' ## Code Owners: Kyle Baird, Shea Parkes
#' ### OWNERS ATTEST TO THE FOLLOWING:
#'   * The `master` branch will meet Milliman QRM standards at all times.
#'   * Deliveries will only be made from code in the `master` branch.
#'   * Review/Collaboration notes will be captured in Pull Requests (prior to merging).
#' 
#' 
#' ### Objective:
#'   * Return meaningful plots of results to the UI
#' 
#' ### Developer Notes:
#'   * <none>

require(ggplot2)
require(scales)
# source("models.r")

#' ## LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE



plot_results <- function(
  results
) {
  # results <- fit_cts("Ragsdale, bacon", "19960-4", c('Epic', 'INPC'), 1, 1)

  plt <- results %>% 
    ggplot(
      aes(x = date.r, y = result)
      ) +
      geom_line(alpha=0.5) +
      geom_point(aes(shape = fhir, color = fhir),size=4.2) +
      theme_bw() +
      ggtitle("Patient Result History") +
      scale_y_continuous(
        name = "Result"
        # ,labels = comma
        ) + scale_x_datetime(name = "Date")
  # plt
  return(plt)
}


#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

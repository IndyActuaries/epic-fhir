#' ## Code Owners: Kyle Baird, Shea Parkes
#'
#' ### Objective:
#'   * Load the data for analytics into native R data structures so it is easy to work with
#'
#' ### Developer Notes:
#'   * <none>

require(ifultools)
path.dir.source <- '../data/'

#' ## LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE



df.labs <- read.csv(
  paste0(path.dir.source, "labs.csv")
  ,header = TRUE
  ,stringsAsFactors = FALSE
  )
df.results <- read.csv(
  paste0(path.dir.source, "results.csv")
  ,header = TRUE
  ,stringsAsFactors = FALSE
  )
df.results$date.r <- as.POSIXct(strptime(substr(df.results$date, 1, 19), "%Y-%m-%dT%H:%M:%S"))
df.results$name <- properCase(df.results$name)
df.patients <- read.csv(
  paste0(path.dir.source, "patients.csv")
  ,header = TRUE
  ,stringsAsFactors = FALSE
  )
df.patients$dob.r <- as.Date(df.patients$dob, "%Y-%m-%dT%H:%M:%SZ")
df.patients$name <- properCase(df.patients$name)

#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

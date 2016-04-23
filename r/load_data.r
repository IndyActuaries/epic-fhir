#' ## Code Owners: Kyle Baird
#' ### OWNERS ATTEST TO THE FOLLOWING:
#'   * The `master` branch will meet Milliman QRM standards at all times.
#'   * Deliveries will only be made from code in the `master` branch.
#'   * Review/Collaboration notes will be captured in Pull Requests (prior to merging).
#' 
#' 
#' ### Objective:
#'   * Load the data for analytics into native R data structures so it is easy to work with
#' 
#' ### Developer Notes:
#'   * <none>

path.dir.source <- paste0(
  Sys.getenv("USERPROFILE")
  ,"/repos/epic-fhir/data/"
  )

#' ## LIBRARIES, LOCATIONS, LITERALS, ETC. GO ABOVE HERE



df.labs <- read.csv(
  paste0(path.dir.source, "labs.csv")
  ,header = TRUE
  ,stringsAsFactors = FALSE
  )
# df.results <- read.csv(
#   paste0(path.dir.source, "results.csv")
#   ,header = TRUE
#   ,stringsAsFactors = FALSE
#   )
df.patients <- read.csv(
  paste0(path.dir.source, "patients.csv")
  ,header = TRUE
  ,stringsAsFactors = FALSE
  )
df.patients$dob.r <- as.Date(df.patients$dob, "%Y-%m-%dT%H:%M:%SZ")

#'
#' _ _ _
#' ## R SPECIFIC FOOTER
sessionInfo()
Sys.time()
proc.time()

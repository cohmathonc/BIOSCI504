#' List course resources
#'
#' Lists the datasets and templates included in the package.
#'
#' @return A data frame with one row per resource.
#' @export
course_resources <- function() {
  data.frame(
    resource = c(
      "mouse_trial",
      "mouse_trial_duplicates",
      "mouse_trial_missingness",
      "mouse_trial_unit_error"
    ),
    type = rep("dataset", 4L),
    alias = rep(NA_character_, 4L),
    day = rep(2L, 4L),
    topic = rep("Tabular comparison", 4L),
    description = c(
      "Core mouse treatment dataset.",
      "Mouse trial with repeated records.",
      "Mouse trial with group-dependent missingness.",
      "Mouse trial with a final-weight unit error."
    ),
    stringsAsFactors = FALSE
  )
}

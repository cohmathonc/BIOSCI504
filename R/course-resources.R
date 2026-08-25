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
      "mouse_trial_unit_error",
      "tabular-comparison"
    ),
    type = c(rep("dataset", 4L), "template"),
    alias = rep(NA_character_, 5L),
    day = rep(2L, 5L),
    topic = rep("Tabular comparison", 5L),
    description = c(
      "Core mouse treatment dataset.",
      "Mouse trial with repeated records.",
      "Mouse trial with group-dependent missingness.",
      "Mouse trial with a final-weight unit error.",
      "Quarto scaffold for a tabular comparison."
    ),
    stringsAsFactors = FALSE
  )
}

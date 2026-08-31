#' List course resources
#'
#' Lists the datasets and templates included in the package.
#'
#' @return A tibble with one row per resource.
#' @export
course_resources <- function() {
  datasets <- tibble::tibble(
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
    )
  )

  dplyr::bind_rows(datasets, course_template_registry())
}

course_template_registry <- function() {
  # fmt: skip
  tibble::tribble(
    ~resource, ~type, ~alias, ~day, ~topic, ~description,
    "working-with-r", "template", "lecture-2", 2L,
    "Working with R and RStudio", "Guided Quarto code-along for working in RStudio.",
    "tabular-comparison", "template", "lecture-3", 2L,
    "Tabular comparison", "Quarto scaffold for a tabular comparison.",
    "explicit-analytical-rules", "template", "day-3", 3L,
    "Explicit analytical rules", "Quarto scaffold for conditions and iteration.",
    "expression-filtering", "template", "day-4", 4L,
    "Expression filtering and transformation",
    "Quarto scaffold for filtering and transforming expression data."
  )
}

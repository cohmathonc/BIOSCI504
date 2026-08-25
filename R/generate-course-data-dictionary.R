.generate_course_data_dictionary <- function() {
  variables <- data.frame(
    variable = c(
      "mouse_id",
      "treatment",
      "sex",
      "baseline_weight_g",
      "final_weight_g",
      "cage",
      "batch"
    ),
    type = c(
      "character",
      "character",
      "character",
      "numeric",
      "numeric",
      "character",
      "character"
    ),
    units = c(NA, NA, NA, "g", "g", NA, NA),
    description = c(
      "Unique mouse identifier.",
      "Treatment assignment.",
      "Recorded sex.",
      "Weight before treatment.",
      "Weight after treatment.",
      "Housing cage identifier.",
      "Experimental batch identifier."
    ),
    allowed_values = c(
      NA,
      "control; treatment",
      "female; male",
      NA,
      NA,
      "C01-C06",
      "B01-B03"
    ),
    stringsAsFactors = FALSE
  )

  dataset_notes <- c(
    mouse_trial = "Core teaching dataset.",
    mouse_trial_duplicates = "Contains repeated records.",
    mouse_trial_missingness = "Contains group-dependent missingness.",
    mouse_trial_unit_error = "Contains a final-weight unit error."
  )

  dictionaries <- lapply(names(dataset_notes), function(dataset) {
    data.frame(
      dataset = dataset,
      variables,
      variant_notes = unname(dataset_notes[[dataset]]),
      stringsAsFactors = FALSE
    )
  })

  rownames(dictionaries) <- NULL
  do.call(rbind, dictionaries)
}

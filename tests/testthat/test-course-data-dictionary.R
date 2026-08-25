test_that("course_data_dictionary describes every mouse trial variable", {
  data("course_data_dictionary", package = "BIOSCI504", envir = environment())

  expect_s3_class(course_data_dictionary, "data.frame")
  expect_identical(
    names(course_data_dictionary),
    c(
      "dataset",
      "variable",
      "type",
      "units",
      "description",
      "allowed_values",
      "variant_notes"
    )
  )
  expect_equal(nrow(course_data_dictionary), 28L)
  expect_equal(
    as.list(table(course_data_dictionary$dataset)),
    list(
      mouse_trial = 7L,
      mouse_trial_duplicates = 7L,
      mouse_trial_missingness = 7L,
      mouse_trial_unit_error = 7L
    )
  )
  expect_equal(
    anyDuplicated(course_data_dictionary[c("dataset", "variable")]),
    0L
  )
  expect_setequal(
    course_data_dictionary$variable,
    c(
      "mouse_id",
      "treatment",
      "sex",
      "baseline_weight_g",
      "final_weight_g",
      "cage",
      "batch"
    )
  )
})

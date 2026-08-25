test_that("mouse_trial_missingness adds group-dependent missingness", {
  data("mouse_trial", package = "BIOSCI504", envir = environment())
  data("mouse_trial_missingness", package = "BIOSCI504", envir = environment())

  expect_identical(names(mouse_trial_missingness), names(mouse_trial))
  unchanged_columns <- names(mouse_trial) != "final_weight_g"
  expect_identical(
    mouse_trial_missingness[unchanged_columns],
    mouse_trial[unchanged_columns]
  )
  expect_identical(mouse_trial_missingness$mouse_id, mouse_trial$mouse_id)
  expect_equal(
    as.list(table(
      mouse_trial_missingness$treatment[
        is.na(mouse_trial_missingness$final_weight_g)
      ]
    )),
    list(control = 1L, treatment = 5L)
  )
})

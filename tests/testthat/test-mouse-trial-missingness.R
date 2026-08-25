test_that("mouse_trial_missingness adds group-dependent missingness", {
  data("mouse_trial", package = "BIOSCI504", envir = environment())
  data("mouse_trial_missingness", package = "BIOSCI504", envir = environment())

  expect_identical(names(mouse_trial_missingness), names(mouse_trial))
  expect_identical(mouse_trial_missingness[-5], mouse_trial[-5])
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

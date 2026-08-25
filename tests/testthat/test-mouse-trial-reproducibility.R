test_that("mouse_trial rebuilds reproducibly", {
  rebuilt_mouse_trial <- BIOSCI504:::.generate_mouse_trial()
  data("mouse_trial", package = "BIOSCI504", envir = environment())
  data("mouse_trial_missingness", package = "BIOSCI504", envir = environment())
  data("mouse_trial_duplicates", package = "BIOSCI504", envir = environment())
  data("mouse_trial_unit_error", package = "BIOSCI504", envir = environment())

  expect_identical(rebuilt_mouse_trial, mouse_trial)
  expect_identical(
    BIOSCI504:::.generate_mouse_trial_missingness(rebuilt_mouse_trial),
    mouse_trial_missingness
  )
  expect_identical(
    BIOSCI504:::.generate_mouse_trial_duplicates(rebuilt_mouse_trial),
    mouse_trial_duplicates
  )
  expect_identical(
    BIOSCI504:::.generate_mouse_trial_unit_error(rebuilt_mouse_trial),
    mouse_trial_unit_error
  )
})

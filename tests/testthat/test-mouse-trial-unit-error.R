test_that("mouse_trial_unit_error contains one mis-scaled final weight", {
  data("mouse_trial", package = "BIOSCI504", envir = environment())
  data("mouse_trial_unit_error", package = "BIOSCI504", envir = environment())

  expect_identical(names(mouse_trial_unit_error), names(mouse_trial))
  expect_identical(mouse_trial_unit_error[-5], mouse_trial[-5])
  expect_identical(
    is.na(mouse_trial_unit_error$final_weight_g),
    is.na(mouse_trial$final_weight_g)
  )

  changed <- which(
    !is.na(mouse_trial$final_weight_g) &
      mouse_trial_unit_error$final_weight_g != mouse_trial$final_weight_g
  )

  expect_length(changed, 1L)
  expect_equal(
    mouse_trial_unit_error$final_weight_g[changed],
    mouse_trial$final_weight_g[changed] * 1000
  )
})

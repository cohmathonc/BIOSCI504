test_that("mouse_trial rebuilds reproducibly", {
  rebuilt_mouse_trial <- BIOSCI504:::.generate_mouse_trial()
  data("mouse_trial", package = "BIOSCI504", envir = environment())

  expect_identical(rebuilt_mouse_trial, mouse_trial)
})

test_that("mouse_trial provides the Day 2 teaching dataset", {
  data("mouse_trial", package = "BIOSCI504", envir = environment())

  expect_s3_class(mouse_trial, "data.frame")
  expect_identical(
    names(mouse_trial),
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
  expect_equal(nrow(mouse_trial), 48L)
  expect_equal(length(unique(mouse_trial$mouse_id)), 48L)
  expect_equal(
    as.list(table(mouse_trial$treatment)),
    list(control = 26L, treatment = 22L)
  )
  expect_setequal(mouse_trial$sex, c("female", "male"))
  expect_equal(length(unique(mouse_trial$cage)), 6L)
  expect_equal(length(unique(mouse_trial$batch)), 3L)
  expect_equal(sum(is.na(mouse_trial$baseline_weight_g)), 1L)
  expect_equal(sum(is.na(mouse_trial$final_weight_g)), 1L)

  weight_change <- mouse_trial$final_weight_g - mouse_trial$baseline_weight_g
  quartiles <- quantile(weight_change, c(0.25, 0.75), na.rm = TRUE)
  upper_fence <- quartiles[[2]] + 1.5 * diff(quartiles)

  expect_equal(sum(weight_change > upper_fence, na.rm = TRUE), 1L)
})

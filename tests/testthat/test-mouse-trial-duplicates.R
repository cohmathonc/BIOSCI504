test_that("mouse_trial_duplicates contains three duplicate records", {
  data("mouse_trial", package = "BIOSCI504", envir = environment())
  data("mouse_trial_duplicates", package = "BIOSCI504", envir = environment())

  expect_identical(names(mouse_trial_duplicates), names(mouse_trial))
  expect_equal(nrow(mouse_trial_duplicates), 51L)
  expect_equal(length(unique(mouse_trial_duplicates$mouse_id)), 48L)
  expect_equal(sum(duplicated(mouse_trial_duplicates)), 3L)

  deduplicated <- mouse_trial_duplicates[!duplicated(mouse_trial_duplicates), ]
  deduplicated <- deduplicated[order(deduplicated$mouse_id), ]
  rownames(deduplicated) <- NULL

  expect_identical(deduplicated, mouse_trial)
})

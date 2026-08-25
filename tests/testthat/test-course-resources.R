test_that("course_resources lists the packaged teaching datasets", {
  resources <- course_resources()

  expect_s3_class(resources, "data.frame")
  expect_identical(
    names(resources),
    c("resource", "type", "alias", "day", "topic", "description")
  )
  expect_setequal(
    resources$resource,
    c(
      "mouse_trial",
      "mouse_trial_duplicates",
      "mouse_trial_missingness",
      "mouse_trial_unit_error"
    )
  )
  expect_true(all(resources$type == "dataset"))
  expect_true(all(is.na(resources$alias)))
  expect_true(all(resources$day == 2L))
  expect_true(all(resources$topic == "Tabular comparison"))

  loaded_resources <- new.env(parent = emptyenv())
  data(
    list = resources$resource,
    package = "BIOSCI504",
    envir = loaded_resources
  )
  expect_true(all(resources$resource %in% ls(loaded_resources)))
})

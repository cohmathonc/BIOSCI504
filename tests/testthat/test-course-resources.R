test_that("course_resources lists the packaged teaching datasets", {
  resources <- course_resources()
  datasets <- resources[resources$type == "dataset", , drop = FALSE]

  expect_s3_class(resources, "data.frame")
  expect_identical(
    names(resources),
    c("resource", "type", "alias", "day", "topic", "description")
  )
  expect_setequal(
    datasets$resource,
    c(
      "mouse_trial",
      "mouse_trial_duplicates",
      "mouse_trial_missingness",
      "mouse_trial_unit_error"
    )
  )
  expect_true(all(is.na(datasets$alias)))
  expect_true(all(datasets$day == 2L))
  expect_true(all(datasets$topic == "Tabular comparison"))

  loaded_resources <- new.env(parent = emptyenv())
  data(
    list = datasets$resource,
    package = "BIOSCI504",
    envir = loaded_resources
  )
  expect_true(all(datasets$resource %in% ls(loaded_resources)))
})

test_that("course_resources lists the tabular comparison template", {
  resources <- course_resources()
  templates <- resources[resources$type == "template", , drop = FALSE]

  expect_identical(templates$resource, "tabular-comparison")
  expect_true(is.na(templates$alias))
  expect_identical(templates$day, 2L)
  expect_identical(templates$topic, "Tabular comparison")
})

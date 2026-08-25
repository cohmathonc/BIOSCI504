test_that("course_data_dictionary rebuilds reproducibly", {
  data("course_data_dictionary", package = "BIOSCI504", envir = environment())

  expect_identical(
    BIOSCI504:::.generate_course_data_dictionary(),
    course_data_dictionary
  )
})

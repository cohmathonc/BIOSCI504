test_that("check_setup returns stable public results", {
  result <- expect_invisible(check_setup())

  expect_s3_class(result, "tbl_df")
  expect_identical(names(result), c("check", "status", "detail", "fix"))
  expect_identical(
    result$check,
    c(
      "r-version",
      "packages",
      "rstudio",
      "quarto",
      "git",
      "write-permission",
      "bundled-data",
      "ggplot",
      "quarto-render"
    )
  )
  expect_true(all(result$status %in% c("pass", "warn", "fail")))
  expect_type(result$detail, "character")
  expect_type(result$fix, "character")
})

test_that("checks backed by the installed package pass", {
  result <- suppressMessages(check_setup())
  installed_checks <- c("r-version", "packages", "bundled-data", "ggplot")

  expect_true(all(result$status[result$check %in% installed_checks] == "pass"))
})

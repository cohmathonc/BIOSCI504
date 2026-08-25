test_that("copy_template copies the tabular comparison scaffold", {
  destination <- tempfile("tabular-comparison-")
  original_directory <- getwd()

  result <- copy_template("tabular-comparison", dest = destination)

  expect_identical(result, invisible(destination))
  expect_setequal(
    list.files(destination, all.files = TRUE, no.. = TRUE),
    c("_brand.yml", "analysis.qmd")
  )
  expect_identical(getwd(), original_directory)
})

test_that("copy_template defaults to the course project exercises directory", {
  project <- tempfile("BIOSCI504-")
  create_course_project(project)
  work_directory <- file.path(project, "work", "day-02")
  dir.create(work_directory, recursive = TRUE)
  original_directory <- setwd(work_directory)
  on.exit(setwd(original_directory), add = TRUE)

  result <- copy_template("tabular-comparison")

  project_root <- dirname(dirname(getwd()))
  destination <- file.path(project_root, "exercises", "tabular-comparison")
  expect_identical(result, invisible(destination))
  expect_true(file.exists(file.path(destination, "analysis.qmd")))
  expect_true(file.exists(file.path(destination, "_brand.yml")))
})

test_that("copy_template requires an explicit destination outside a course project", {
  directory <- tempfile("not-a-course-project-")
  dir.create(directory)
  original_directory <- setwd(directory)
  on.exit(setwd(original_directory), add = TRUE)

  expect_error(
    copy_template("tabular-comparison"),
    "`dest` is required outside a BIOSCI504 course project.",
    fixed = TRUE
  )
})

test_that("copy_template reports the available template for an unknown name", {
  expect_error(
    copy_template("unknown", dest = tempfile()),
    "Unknown template `unknown`. Available template: `tabular-comparison`.",
    fixed = TRUE
  )
})

test_that("copy_template validates its public arguments", {
  expect_error(
    copy_template(character(), dest = tempfile()),
    "`template` must be a single, non-empty name.",
    fixed = TRUE
  )
  expect_error(
    copy_template("tabular-comparison", dest = NA_character_),
    "`dest` must be a single, non-empty path.",
    fixed = TRUE
  )
  expect_error(
    copy_template("tabular-comparison", dest = tempfile(), overwrite = NA),
    "`overwrite` must be `TRUE` or `FALSE`.",
    fixed = TRUE
  )
})

test_that("copy_template protects existing work unless overwrite is requested", {
  destination <- tempfile("tabular-comparison-")
  dir.create(destination)
  writeLines("student work", file.path(destination, "analysis.qmd"))
  writeLines("keep me", file.path(destination, "notes.txt"))

  expect_error(
    copy_template("tabular-comparison", dest = destination),
    "Destination already exists",
    fixed = TRUE
  )
  expect_identical(readLines(file.path(destination, "analysis.qmd")), "student work")

  copy_template("tabular-comparison", dest = destination, overwrite = TRUE)

  expect_true(any(grepl("Biological question", readLines(file.path(destination, "analysis.qmd")))))
  expect_identical(readLines(file.path(destination, "notes.txt")), "keep me")
})

test_that("the tabular comparison scaffold follows the agreed analysis workflow", {
  template <- system.file(
    "templates",
    "tabular-comparison",
    "analysis.qmd",
    package = "BIOSCI504"
  )
  lines <- readLines(template)
  sections <- sub("^## ", "", grep("^## ", lines, value = TRUE))

  expect_identical(
    sections,
    c(
      "Biological question",
      "Prediction",
      "Analysis specification",
      "Data inspection",
      "Analysis code",
      "Verification checkpoints",
      "Result",
      "Interpretation",
      "Why I trust this"
    )
  )
  expect_true(any(grepl("library(BIOSCI504)", lines, fixed = TRUE)))
  expect_true(any(grepl("data(mouse_trial)", lines, fixed = TRUE)))
  expect_true(any(lines == "brand: _brand.yml"))
  expect_lt(match("      - cosmo", lines), match("      - brand", lines))
  expect_false(any(lines == "  warning: false"))
})

test_that("copy_template copies each exercise scaffold", {
  templates <- c(
    "working-with-r",
    "tabular-comparison",
    "explicit-analytical-rules",
    "expression-filtering"
  )
  original_directory <- getwd()

  purrr::walk(templates, function(template) {
    destination <- tempfile(paste0(template, "-"))
    result <- copy_template(template, dest = destination)

    expect_identical(result, invisible(destination))
    expect_setequal(
      list.files(destination, all.files = TRUE, no.. = TRUE),
      c("_brand.yml", "analysis.qmd")
    )
  })
  expect_identical(getwd(), original_directory)
})

test_that("copy_template resolves teaching aliases to canonical templates", {
  aliases <- c(
    "lecture-2" = "working-with-r",
    "lecture-3" = "tabular-comparison",
    "day-3" = "explicit-analytical-rules",
    "day-4" = "expression-filtering"
  )

  purrr::iwalk(aliases, function(template, alias) {
    destination <- tempfile(paste0(alias, "-"))
    copy_template(alias, dest = destination)

    copied <- readLines(file.path(destination, "analysis.qmd"))
    source <- readLines(
      system.file("templates", template, "analysis.qmd", package = "BIOSCI504")
    )
    expect_identical(copied, source)
  })
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
    paste0(
      "Unknown template `unknown`. Available templates: ",
      "`working-with-r`, `tabular-comparison`, ",
      "`explicit-analytical-rules`, ",
      "`expression-filtering`."
    ),
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

test_that("the working with R scaffold supports the guided code-along", {
  template <- system.file(
    "templates",
    "working-with-r",
    "analysis.qmd",
    package = "BIOSCI504"
  )
  lines <- readLines(template)
  sections <- sub("^## ", "", grep("^## ", lines, value = TRUE))

  expect_identical(
    sections,
    c(
      "Console and document",
      "The Console is a REPL",
      "Question and prediction",
      "Common atomic storage types",
      "Missing values retain a type",
      "Objects and vectors",
      "A small tibble",
      "Missing, undefined, infinite or absent?",
      "Missingness is an analytical decision",
      "Result and check",
      "Read an error",
      "Read a warning",
      "Restart and render",
      "What persisted?"
    )
  )
  expect_true(any(grepl("library(tidyverse)", lines, fixed = TRUE)))
  expect_true(any(grepl("weights_g <- c(", lines, fixed = TRUE)))
  expect_true(any(grepl("mean(weights_g)", lines, fixed = TRUE)))
  expect_true(any(grepl("mean(weight_g)", lines, fixed = TRUE)))
  expect_true(any(grepl("length(weights_g)", lines, fixed = TRUE)))
  expect_true(any(grepl("range(weights_g)", lines, fixed = TRUE)))
  expect_true(any(grepl("read-evaluate-print loop", lines, fixed = TRUE)))
  expect_true(any(grepl("typeof(18.2)", lines, fixed = TRUE)))
  expect_true(any(grepl("typeof(18L)", lines, fixed = TRUE)))
  expect_true(any(grepl('typeof("M01")', lines, fixed = TRUE)))
  expect_true(any(grepl("typeof(TRUE)", lines, fixed = TRUE)))
  expect_true(any(grepl("NA_integer_", lines, fixed = TRUE)))
  expect_true(any(grepl("NA_real_", lines, fixed = TRUE)))
  expect_true(any(grepl("NA_complex_", lines, fixed = TRUE)))
  expect_true(any(grepl("NA_character_", lines, fixed = TRUE)))
  expect_true(any(grepl(
    'is.na(c("M01", NA_character_, "NA"))',
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("glimpse(measurements)", lines, fixed = TRUE)))
  expect_true(any(grepl("typeof(measurements)", lines, fixed = TRUE)))
  expect_true(any(grepl("class(measurements)", lines, fixed = TRUE)))
  expect_true(any(grepl("is.nan(special_values)", lines, fixed = TRUE)))
  expect_true(any(grepl("is.infinite(special_values)", lines, fixed = TRUE)))
  expect_true(any(grepl("is.finite(special_values)", lines, fixed = TRUE)))
  expect_true(any(grepl("is.null(NULL)", lines, fixed = TRUE)))
  expect_true(any(grepl("na.rm = TRUE", lines, fixed = TRUE)))
  expect_true(any(grepl("measurements$weight_g", lines, fixed = TRUE)))
  expect_true(any(grepl("mean(mixed_weights)", lines, fixed = TRUE)))
  expect_true(any(grepl("treatment effect", lines, fixed = TRUE)))
  expect_true(any(grepl("Restart R", lines, fixed = TRUE)))
  expect_true(any(grepl("Render", lines, fixed = TRUE)))
  expect_true(any(lines == "brand: _brand.yml"))
  expect_false(any(grepl("mouse_trial", lines, fixed = TRUE)))
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
  expect_identical(
    readLines(file.path(destination, "analysis.qmd")),
    "student work"
  )

  copy_template("tabular-comparison", dest = destination, overwrite = TRUE)

  expect_true(any(grepl(
    "Situation",
    readLines(file.path(destination, "analysis.qmd"))
  )))
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
      "Situation",
      "Question and prediction",
      "How the data arose",
      "Analysis specification",
      "Data inspection",
      "Explain or debug with AI",
      "Compare final weight",
      "Derive and compare weight change",
      "Final verification",
      "Result",
      "Interpretation",
      "Why I trust this",
      "Optional extension"
    )
  )
  expect_true(any(grepl("library(BIOSCI504)", lines, fixed = TRUE)))
  expect_true(any(grepl("library(tidyverse)", lines, fixed = TRUE)))
  expect_true(any(grepl("data(mouse_trial)", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "without generating the analysis",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("weight_change_g", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "Commit to an expectation before seeing the group comparison",
    lines,
    fixed = TRUE
  )))
  expect_true(any(lines == "brand: _brand.yml"))
  expect_lt(match("      - cosmo", lines), match("      - brand", lines))
  expect_false(any(lines == "  warning: false"))
})

test_that("the Day 3 scaffold makes analytical rules explicit", {
  template <- system.file(
    "templates",
    "explicit-analytical-rules",
    "analysis.qmd",
    package = "BIOSCI504"
  )
  lines <- readLines(template)
  sections <- sub("^## ", "", grep("^## ", lines, value = TRUE))

  expect_identical(
    sections,
    c(
      "Situation",
      "Review rule",
      "Expected classifications",
      "Executable specification",
      "Constrained AI generation",
      "Small-case test",
      "Scale the operation",
      "Conditional outcome",
      "Custom function",
      "Explicit iteration",
      "Final verification",
      "Result",
      "Interpretation",
      "Why I trust this",
      "Optional extensions"
    )
  )
  expect_true(any(grepl("data(mouse_trial)", lines, fixed = TRUE)))
  expect_true(any(grepl("rule_cases <- tibble::tribble", lines, fixed = TRUE)))
  expect_true(any(grepl(
    '"case_4", "treatment", 21.0, 20.0',
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("&", lines, fixed = TRUE)))
  expect_true(any(grepl("|", lines, fixed = TRUE)))
  expect_true(any(grepl("if_else()", lines, fixed = TRUE)))
  expect_true(any(grepl("more than 1.0 g", lines, fixed = TRUE)))
  expect_true(any(grepl("data(airway", lines, fixed = TRUE)))
  expect_true(any(lines == "#| eval: false"))
})

test_that("the Day 4 scaffold distinguishes filtering from transformation", {
  template <- system.file(
    "templates",
    "expression-filtering",
    "analysis.qmd",
    package = "BIOSCI504"
  )
  lines <- readLines(template)
  sections <- sub("^## ", "", grep("^## ", lines, value = TRUE))

  expect_identical(
    sections,
    c(
      "Situation",
      "Biological question",
      "Inspect the representation",
      "Commit before changing the data",
      "Filter and checkpoint",
      "Transform and checkpoint",
      "Compare strategies",
      "Result",
      "Interpretation",
      "Why I trust this",
      "Optional extensions"
    )
  )
  expect_true(any(grepl("expression_counts <- matrix", lines, fixed = TRUE)))
  expect_true(any(grepl("Filtering changes what remains", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "Transformation changes how",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("count is at least 10", lines, fixed = TRUE)))
  expect_true(any(grepl("least two samples", lines, fixed = TRUE)))
  expect_true(any(grepl("log2(count + 1)", lines, fixed = TRUE)))
  expect_true(any(grepl("data(airway", lines, fixed = TRUE)))
  expect_true(any(lines == "#| eval: false"))
  expect_true(any(grepl("Normalization", lines, fixed = TRUE)))
})

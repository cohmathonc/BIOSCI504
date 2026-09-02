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

test_that("the Day 3 scaffold follows the logical-operations lesson", {
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
      "Start",
      "Inspect the mouse trial",
      "Identify missing measurements",
      "Keep complete records",
      "Compare treatment labels",
      "Compare weight change",
      "Make one decision",
      "Combine the conditions",
      "Filter the selected mice",
      "Give the filter a reusable name",
      "Repeat the filter",
      "Choose a continuation",
      "Finish",
      "Further reading"
    )
  )
  expect_true(any(grepl("data(mouse_trial)", lines, fixed = TRUE)))
  expect_true(any(grepl("trial <- mouse_trial", lines, fixed = TRUE)))
  expect_true(any(grepl("is.na(", lines, fixed = TRUE)))
  expect_true(any(grepl("missing_required_weight", lines, fixed = TRUE)))
  expect_true(any(grepl("complete_mouse_records", lines, fixed = TRUE)))
  expect_true(any(grepl("received_treatment", lines, fixed = TRUE)))
  expect_true(any(grepl("gained_at_least_3_g", lines, fixed = TRUE)))
  expect_true(any(grepl("not-equal operator (`!=`)", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "if (current_weight_change_g >= 3)",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("} else {", lines, fixed = TRUE)))
  expect_true(any(grepl("meets_both_conditions", lines, fixed = TRUE)))
  expect_true(any(grepl("`&`", lines, fixed = TRUE)))
  expect_true(any(grepl("`filter()`", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "Rows with `FALSE` or",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl(
    "filter_treated_mice_by_weight_gain <- function(",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("dplyr::filter(", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "for (minimum_weight_gain_g in c(2, 3, 4))",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("21, 5, and 1", lines, fixed = TRUE)))
  expect_true(any(grepl(
    "control_mice_gaining_at_least_2_g",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl(
    "filter_mice_by_treatment_and_gain(",
    lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("count(batch, cage)", lines, fixed = TRUE)))
  expect_true(any(grepl("Restart R", lines, fixed = TRUE)))
  expect_true(any(grepl("analysis.html", lines, fixed = TRUE)))
  expect_true(any(lines == "#| eval: false"))
  expect_false(any(grepl("case_when", lines, fixed = TRUE)))
  expect_false(any(grepl("batch_coverage", lines, fixed = TRUE)))
  expect_false(any(grepl("cage_coverage", lines, fixed = TRUE)))
  expect_false(any(grepl("classify_weight_response", lines, fixed = TRUE)))
  expect_false(any(grepl("purrr::map", lines, fixed = TRUE)))
  expect_false(any(grepl("pivot_wider", lines, fixed = TRUE)))
  expect_false(any(grepl("high_response", lines, fixed = TRUE)))
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

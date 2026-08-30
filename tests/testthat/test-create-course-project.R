test_that("create_course_project creates a project without changing directories", {
  project_path <- tempfile("BIOSCI504-")
  original_directory <- getwd()

  create_course_project(project_path)

  expect_setequal(
    list.files(project_path, all.files = TRUE, no.. = TRUE),
    c(
      ".Rprofile",
      "BIOSCI504.Rproj",
      "_quarto.yml",
      "README.md",
      "exercises"
    )
  )
  expect_true(dir.exists(file.path(project_path, "exercises")))
  expect_identical(getwd(), original_directory)

  profile <- readLines(file.path(project_path, ".Rprofile"))
  expect_true(any(grepl(
    'repos["CRAN"] <- "https://cloud.r-project.org"',
    profile,
    fixed = TRUE
  )))
  expect_true(any(grepl(
    'install.packages.compile.from.source = "never"',
    profile,
    fixed = TRUE
  )))
  expect_silent(parse(file = file.path(project_path, ".Rprofile")))

  project_readme <- readLines(file.path(project_path, "README.md"))
  expect_true(any(grepl(
    "Open `BIOSCI504.Rproj` in RStudio",
    project_readme,
    fixed = TRUE
  )))
})

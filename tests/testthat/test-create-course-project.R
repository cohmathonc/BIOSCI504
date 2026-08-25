test_that("create_course_project creates a project without changing directories", {
  project_path <- tempfile("BIOSCI504-")
  original_directory <- getwd()

  create_course_project(project_path)

  expect_setequal(
    list.files(project_path, all.files = TRUE, no.. = TRUE),
    c("BIOSCI504.Rproj", "_quarto.yml", "README.md", "exercises")
  )
  expect_true(dir.exists(file.path(project_path, "exercises")))
  expect_identical(getwd(), original_directory)
})

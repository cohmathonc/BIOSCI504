#' Create a course project
#'
#' Creates an RStudio and Quarto project for BIOSCI 504 exercises.
#'
#' @param path Where to create the project.
#'
#' @return The expanded project path, invisibly.
#' @export
create_course_project <- function(path) {
  if (
    !is.character(path) || length(path) != 1L || is.na(path) || !nzchar(path)
  ) {
    stop("`path` must be a single, non-empty path.", call. = FALSE)
  }

  path <- path.expand(path)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(path, "exercises"), showWarnings = FALSE)

  writeLines(
    c(
      "Version: 1.0",
      "",
      "RestoreWorkspace: No",
      "SaveWorkspace: No",
      "AlwaysSaveHistory: Default",
      "",
      "EnableCodeIndexing: Yes",
      "UseSpacesForTab: Yes",
      "NumSpacesForTab: 2",
      "Encoding: UTF-8",
      "",
      "RnwWeave: knitr",
      "LaTeX: pdfLaTeX"
    ),
    file.path(path, "BIOSCI504.Rproj")
  )

  writeLines(
    c(
      "project:",
      "  type: default",
      "",
      "format:",
      "  html:",
      "    toc: true"
    ),
    file.path(path, "_quarto.yml")
  )

  writeLines(
    c(
      "local({",
      "  repos <- getOption(\"repos\")",
      "  repos[\"CRAN\"] <- \"https://cloud.r-project.org\"",
      "  options(repos = repos)",
      "",
      "  if (.Platform$OS.type == \"windows\") {",
      "    options(install.packages.compile.from.source = \"never\")",
      "  }",
      "})"
    ),
    file.path(path, ".Rprofile")
  )

  writeLines(
    c(
      "# BIOSCI504",
      "",
      "Use this project for BIOSCI 504 exercises.",
      "Open `BIOSCI504.Rproj` in RStudio before you begin.",
      "Put each exercise in `exercises/`."
    ),
    file.path(path, "README.md")
  )

  invisible(path)
}

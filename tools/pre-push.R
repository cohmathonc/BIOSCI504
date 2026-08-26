run_pre_push_checks <- function() {
  required_packages <- c("knitr", "rcmdcheck", "rmarkdown")
  installed <- vapply(
    required_packages,
    requireNamespace,
    quietly = TRUE,
    FUN.VALUE = logical(1)
  )
  if (!all(installed)) {
    missing <- required_packages[!installed]
    stop(
      paste0(
        "Install the packages required for local checks: ",
        "install.packages(c(",
        paste(sprintf('"%s"', missing), collapse = ", "),
        "))."
      ),
      call. = FALSE
    )
  }

  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) {
    stop("Install Quarto before pushing.", call. = FALSE)
  }

  repo <- system2("git", c("rev-parse", "--show-toplevel"), stdout = TRUE)
  if (length(repo) != 1L || !nzchar(repo)) {
    stop("Run this check from the BIOSCI504 Git repository.", call. = FALSE)
  }
  repo <- normalizePath(repo)

  work <- tempfile("BIOSCI504-pre-push-")
  dir.create(work)
  on.exit(unlink(work, recursive = TRUE, force = TRUE), add = TRUE)

  message("Running R CMD check...")
  rcmdcheck::rcmdcheck(
    path = repo,
    args = "--no-manual",
    build_args = c("--no-manual", "--compact-vignettes=gs+qpdf"),
    check_dir = file.path(work, "check"),
    error_on = "note"
  )

  message("Installing BIOSCI504 into a temporary library...")
  library_path <- file.path(work, "library")
  dir.create(library_path)
  install_status <- system2(
    file.path(R.home("bin"), "R"),
    c(
      "CMD",
      "INSTALL",
      paste0("--library=", shQuote(library_path)),
      shQuote(repo)
    )
  )
  if (!identical(install_status, 0L)) {
    stop("BIOSCI504 could not be installed for the render check.", call. = FALSE)
  }

  .libPaths(c(library_path, .libPaths()))
  loadNamespace("BIOSCI504", lib.loc = library_path)

  project <- file.path(work, "course-project")
  BIOSCI504::create_course_project(project)
  BIOSCI504::copy_template(
    "tabular-comparison",
    dest = file.path(project, "exercises", "tabular-comparison")
  )

  message("Rendering the Quarto exercise template...")
  original_directory <- setwd(project)
  on.exit(setwd(original_directory), add = TRUE)
  render_status <- system2(
    quarto,
    c("render", "exercises/tabular-comparison/analysis.qmd"),
    env = paste0("R_LIBS=", paste(.libPaths(), collapse = .Platform$path.sep))
  )
  if (!identical(render_status, 0L)) {
    stop("The Quarto exercise template did not render.", call. = FALSE)
  }

  message("Pre-push checks passed.")
  invisible(TRUE)
}

run_pre_push_checks()

#' Copy an exercise template
#'
#' Copies a self-contained exercise scaffold from the package.
#'
#' @param template Template name.
#' @param dest Destination directory. When `NULL`, the function looks upward
#'   from the working directory for a project made by [create_course_project()]
#'   and copies to `exercises/<template>`.
#' @param overwrite Whether to replace existing template files. Other files in
#'   the destination are preserved.
#'
#' @return The expanded destination path, invisibly.
#' @export
copy_template <- function(template, dest = NULL, overwrite = FALSE) {
  if (
    !is.character(template) || length(template) != 1L ||
      is.na(template) || !nzchar(template)
  ) {
    stop("`template` must be a single, non-empty name.", call. = FALSE)
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("`overwrite` must be `TRUE` or `FALSE`.", call. = FALSE)
  }

  available_templates <- "tabular-comparison"
  if (!identical(template, available_templates)) {
    stop(
      sprintf(
        "Unknown template `%s`. Available template: `tabular-comparison`.",
        template
      ),
      call. = FALSE
    )
  }

  template_path <- system.file("templates", template, package = "BIOSCI504")
  if (is.null(dest)) {
    project_root <- find_course_project(getwd())
    if (is.null(project_root)) {
      stop(
        "`dest` is required outside a BIOSCI504 course project.",
        call. = FALSE
      )
    }
    dest <- file.path(project_root, "exercises", template)
  }
  if (!is.character(dest) || length(dest) != 1L || is.na(dest) || !nzchar(dest)) {
    stop("`dest` must be a single, non-empty path.", call. = FALSE)
  }
  dest <- path.expand(dest)
  if (dir.exists(dest) && !isTRUE(overwrite)) {
    stop(
      paste0(
        "Destination already exists: `", dest, "`. ",
        "Set `overwrite = TRUE` to replace template files."
      ),
      call. = FALSE
    )
  }
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)

  files <- list.files(template_path, all.files = TRUE, no.. = TRUE)
  file.copy(
    file.path(template_path, files),
    file.path(dest, files),
    overwrite = overwrite
  )

  invisible(dest)
}

find_course_project <- function(path) {
  repeat {
    if (
      file.exists(file.path(path, "BIOSCI504.Rproj")) &&
        dir.exists(file.path(path, "exercises"))
    ) {
      return(path)
    }

    parent <- dirname(path)
    if (identical(parent, path)) {
      return(NULL)
    }
    path <- parent
  }
}

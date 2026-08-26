#' Check the course setup
#'
#' Runs the small checks needed for Days 1--4 and reports how to fix any
#' problems it finds. Checks continue after a failure so that students see the
#' complete result.
#'
#' @return Invisibly, a tibble with columns `check`, `status`, `detail`, and
#'   `fix`. Status is one of `"pass"`, `"warn"`, or `"fail"`.
#' @examples
#' \dontrun{
#' check_setup()
#' }
#' @importFrom rlang .data
#' @export
check_setup <- function() {
  results <- setup_checks() |>
    purrr::imap(run_setup_check) |>
    purrr::list_rbind()

  print_setup_results(results)
  invisible(results)
}

setup_checks <- function() {
  list(
    "r-version" = check_r_version,
    "packages" = check_packages,
    "rstudio" = check_rstudio,
    "quarto" = check_quarto,
    "git" = check_git,
    "write-permission" = check_write_permission,
    "bundled-data" = check_bundled_data,
    "ggplot" = check_ggplot,
    "quarto-render" = check_quarto_render
  )
}

run_setup_check <- function(check, check_name) {
  result <- tryCatch(
    check(),
    error = function(error) {
      setup_result(
        "fail",
        conditionMessage(error),
        "Restart R and run check_setup() again."
      )
    }
  )

  tibble::tibble(
    check = check_name,
    status = result$status,
    detail = result$detail,
    fix = result$fix
  )
}

setup_result <- function(status, detail, fix = "") {
  list(status = status, detail = detail, fix = fix)
}

package_requirements <- function() {
  description <- utils::packageDescription("BIOSCI504")
  fields <- unname(unlist(description[c("Depends", "Imports")]))
  specifications <- stringr::str_split_1(paste(fields, collapse = ","), ",")
  matches <- stringr::str_match(
    stringr::str_trim(specifications),
    "^([[:alnum:].]+)(?:\\s*\\(>=\\s*([^)]+)\\))?$"
  )

  tibble::tibble(
    package = matches[, 2],
    minimum = matches[, 3]
  ) |>
    dplyr::filter(!is.na(.data$package))
}

check_r_version <- function() {
  requirement <- package_requirements() |>
    dplyr::filter(.data$package == "R")
  minimum <- requirement$minimum[[1]]
  current <- as.character(getRversion())

  if (utils::compareVersion(current, minimum) >= 0L) {
    return(setup_result("pass", paste("R", current)))
  }

  setup_result(
    "fail",
    paste("R", current, "is older than", minimum),
    paste("Install R", minimum, "or newer.")
  )
}

check_packages <- function() {
  requirements <- package_requirements() |>
    dplyr::filter(.data$package != "R")
  teaching_packages <- tidyverse::tidyverse_packages()
  requirements <- dplyr::bind_rows(
    requirements,
    tibble::tibble(
      package = setdiff(teaching_packages, requirements$package),
      minimum = NA_character_
    )
  )
  installed <- purrr::map_lgl(
    requirements$package,
    requireNamespace,
    quietly = TRUE
  )
  missing <- requirements$package[!installed]

  current <- purrr::map_chr(
    requirements$package[installed],
    ~ as.character(utils::packageVersion(.x))
  )
  required <- requirements$minimum[installed]
  outdated <- requirements$package[installed][
    !is.na(required) &
      purrr::map2_lgl(current, required, ~ utils::compareVersion(.x, .y) < 0L)
  ]

  problems <- c(missing, outdated)
  if (length(problems) == 0L) {
    return(setup_result(
      "pass",
      paste(nrow(requirements), "required packages are available")
    ))
  }

  setup_result(
    "fail",
    paste("Missing or outdated:", paste(problems, collapse = ", ")),
    paste0(
      "Run install.packages(c(",
      paste(sprintf('"%s"', problems), collapse = ", "),
      "))."
    )
  )
}

check_rstudio <- function() {
  if (identical(Sys.getenv("RSTUDIO"), "1")) {
    return(setup_result("pass", "Running in RStudio"))
  }

  setup_result(
    "warn",
    "RStudio was not detected",
    "Use the current RStudio release for course sessions."
  )
}

check_quarto <- function() {
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) {
    return(setup_result(
      "fail",
      "Quarto was not found",
      "Install Quarto, then restart RStudio."
    ))
  }

  version <- suppressWarnings(
    system2(quarto, "--version", stdout = TRUE, stderr = TRUE)
  )
  status <- attr(version, "status")
  if (!is.null(status) && status != 0L) {
    return(setup_result(
      "fail",
      "Quarto did not run",
      "Reinstall Quarto, then restart RStudio."
    ))
  }

  setup_result("pass", paste("Quarto", version[[1]]))
}

check_git <- function() {
  git <- Sys.which("git")
  if (!nzchar(git)) {
    return(setup_result(
      "fail",
      "Git was not found",
      "Install Git, then restart RStudio."
    ))
  }

  version <- suppressWarnings(
    system2(git, "--version", stdout = TRUE, stderr = TRUE)
  )
  status <- attr(version, "status")
  if (!is.null(status) && status != 0L) {
    return(setup_result(
      "fail",
      "Git did not run",
      "Reinstall Git, then restart RStudio."
    ))
  }

  setup_result("pass", version[[1]])
}

check_write_permission <- function() {
  path <- tempfile("biosci504-write-", tmpdir = getwd())
  on.exit(unlink(path), add = TRUE)

  if (isTRUE(file.create(path))) {
    return(setup_result("pass", "The current directory is writable"))
  }

  setup_result(
    "fail",
    "The current directory is not writable",
    "Move the course project to a folder where you can create files."
  )
}

load_mouse_trial <- function() {
  data_environment <- new.env(parent = emptyenv())
  utils::data(
    list = "mouse_trial",
    package = "BIOSCI504",
    envir = data_environment
  )
  get("mouse_trial", envir = data_environment, inherits = FALSE)
}

check_bundled_data <- function() {
  mouse_trial <- load_mouse_trial()
  if (inherits(mouse_trial, "data.frame") && nrow(mouse_trial) > 0L) {
    return(setup_result("pass", "Bundled course data loaded"))
  }

  setup_result(
    "fail",
    "Bundled course data did not load correctly",
    "Reinstall BIOSCI504."
  )
}

check_ggplot <- function() {
  plot <- ggplot2::ggplot() +
    ggplot2::geom_point(ggplot2::aes(x = c(1, 2), y = c(1, 2)))
  ggplot2::ggplot_build(plot)

  setup_result("pass", "A basic ggplot built successfully")
}

check_quarto_render <- function() {
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) {
    return(setup_result(
      "fail",
      "A Quarto document could not be rendered",
      "Install Quarto, then restart RStudio."
    ))
  }

  r_engine <- knitr::knit_engines$get("R")
  if (!is.function(r_engine)) {
    return(setup_result(
      "fail",
      "R document rendering support is incomplete",
      "Reinstall knitr and rmarkdown, then restart RStudio."
    ))
  }

  render_directory <- tempfile("biosci504-render-")
  dir.create(render_directory)
  on.exit(unlink(render_directory, recursive = TRUE), add = TRUE)
  input <- file.path(render_directory, "check.qmd")
  writeLines(
    c(
      "---",
      "title: Setup check",
      "format: html",
      "---",
      "",
      "```{r}",
      "1 + 1",
      "```"
    ),
    input
  )
  front_matter <- rmarkdown::yaml_front_matter(input)
  if (!identical(front_matter$format, "html")) {
    return(setup_result(
      "fail",
      "The Quarto document metadata could not be read",
      "Reinstall rmarkdown, then restart RStudio."
    ))
  }

  output <- suppressWarnings(
    system2(
      quarto,
      c("render", shQuote(input), "--quiet"),
      stdout = TRUE,
      stderr = TRUE
    )
  )
  status <- attr(output, "status")
  rendered <- file.exists(file.path(render_directory, "check.html"))

  if ((is.null(status) || status == 0L) && rendered) {
    return(setup_result("pass", "A minimal Quarto document rendered"))
  }

  setup_result(
    "fail",
    "A Quarto document could not be rendered",
    "Restart RStudio and reinstall knitr and rmarkdown."
  )
}

print_setup_results <- function(results) {
  cli::cli_h2("BIOSCI504 setup")
  purrr::pwalk(
    results,
    function(check, status, detail, fix) {
      label <- switch(
        status,
        pass = cli::col_green("PASS"),
        warn = cli::col_yellow("WARN"),
        fail = cli::col_red("FAIL")
      )
      cli::cli_text("{label} {check}: {detail}")
      if (status != "pass" && nzchar(fix)) {
        cli::cli_text("  {fix}")
      }
    }
  )

  failures <- sum(results$status == "fail")
  warnings <- sum(results$status == "warn")
  if (failures > 0L) {
    cli::cli_alert_danger("{failures} setup check(s) need attention.")
  } else if (warnings > 0L) {
    cli::cli_alert_warning("Setup is ready with {warnings} warning(s).")
  } else {
    cli::cli_alert_success("Setup is ready.")
  }
}

# BIOSCI504

`BIOSCI504` provides datasets and setup tools for BIOSCI 504.

Read the documentation at <https://cohmathonc.github.io/BIOSCI504/>.

## First installation on Windows

Use this route if `BIOSCI504` is not already installed. It installs the
released Windows binary and does not require Rtools.

```r
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages(
  "pak",
  repos = sprintf(
    "https://r-lib.github.io/p/pak/stable/%s/%s/%s",
    .Platform$pkgType,
    R.Version()$os,
    R.Version()$arch
  )
)
pak::pkg_install(
  sprintf(
    paste0(
      "BIOSCI504=url::https://github.com/cohmathonc/BIOSCI504/",
      "releases/latest/download/BIOSCI504-windows-R-%s-x86_64.zip"
    ),
    paste(R.version$major, sub("\\..*$", "", R.version$minor), sep = ".")
  ),
  upgrade = FALSE
)
```

## Updating an existing installation on Windows

Use this route if `BIOSCI504` is already installed. Save your work and restart
R before updating the package. Do not load `BIOSCI504` in the new session.
Then run:

```r
pak::pkg_install(
  sprintf(
    paste0(
      "BIOSCI504=url::https://github.com/cohmathonc/BIOSCI504/",
      "releases/latest/download/",
      "BIOSCI504-windows-R-%s-x86_64.zip?reinstall"
    ),
    paste(R.version$major, sub("\\..*$", "", R.version$minor), sep = ".")
  ),
  upgrade = FALSE,
  ask = FALSE
)
```

Restart R again after the installation finishes. A package update changes the
templates available to `copy_template()`; it does not replace exercises that
you have already copied.

Check the software needed for the course:

```r
BIOSCI504::check_setup()
```

## Use the course data

```r
data(mouse_trial, package = "BIOSCI504")
```

`mouse_trial` contains baseline and final weights for a simulated treatment study.

## Find available resources

```r
BIOSCI504::course_resources()
data(course_data_dictionary, package = "BIOSCI504")
```

## Create a course project

```r
BIOSCI504::create_course_project("~/BIOSCI504")
```

This creates an RStudio and Quarto project with a directory for exercises.
Open `~/BIOSCI504/BIOSCI504.Rproj` in RStudio before continuing.

## Get started

See `vignette("getting-started", package = "BIOSCI504")` for the complete
student workflow.

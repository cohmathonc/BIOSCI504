# BIOSCI504

`BIOSCI504` provides datasets and setup tools for BIOSCI 504.

Read the documentation at <https://cohmathonc.github.io/BIOSCI504/>.

## Install

```r
options(repos = c(CRAN = "https://cloud.r-project.org"))
install.packages("pak")
pak::pak("cohmathonc/BIOSCI504")
```

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

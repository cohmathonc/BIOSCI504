# BIOSCI504

`BIOSCI504` provides datasets and setup tools for BIOSCI 504.

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

## Development status

The package is under active development. Installation instructions will be added before the first release.

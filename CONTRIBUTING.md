# Contributing

`BIOSCI504` contains student-facing course tools.

Please propose changes with a pull request. Changes should:

- solve a real course-data, setup, or file-management problem;
- treat challenge datasets as transparent teaching fixtures;
- keep complete worked analyses and hidden assessment logic out of the package;
- keep course-management material out of the package.

Use a pull request to propose dependency changes.

Prefer tidyverse idioms for tabular data and visualization. In package code,
call dependencies explicitly with `package::function()`; do not attach them
with `library()`. Base R remains the natural choice for matrices, fundamental
language concepts, and low-level system or filesystem work.

## Local checks

Enable the tracked pre-push hook once in each clone:

```sh
git config core.hooksPath .githooks
```

The hook validates GitHub Actions workflows, checks R formatting with Air,
regenerates package documentation to detect drift, runs `R CMD check`, builds
the pkgdown site, and renders every Quarto exercise template. Install
`actionlint` or Go, Air or `uvx`, and the `roxygen2`, `pkgdown`, and `rcmdcheck`
R packages. GitHub Actions remains responsible for the full operating-system
and R-version matrix.

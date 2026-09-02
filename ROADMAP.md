# BIOSCI504 roadmap

`BIOSCI504` is course infrastructure. It should remove setup and file-management friction, then stay out of the way.

## 1. Package foundation

- [x] Create a conventional R package.
- [x] Add package metadata, documentation, tests, and an MIT license.
- [x] Add `create_course_project(path)`.
- [x] Test that project creation leaves the working directory unchanged.
- [x] Add package-development checks for formatting and documentation.

## 2. Day 2 data

- [x] Write a seeded `data-raw/` script for `mouse_trial`.
- [x] Include the required columns:
  - `mouse_id`
  - `treatment`
  - `sex`
  - `baseline_weight_g`
  - `final_weight_g`
  - `cage`
  - `batch`
- [x] Build in mild cage and batch effects, slight imbalance, 1–2 missing values, and one plausible biological outlier.
- [x] Record the known data-generating assumptions for maintainers.
- [x] Add `mouse_trial_missingness`.
- [x] Add `mouse_trial_duplicates`.
- [x] Add `mouse_trial_unit_error`.
- [x] Add standard help pages for each dataset.
- [x] Test schemas, identifiers, fixed dimensions, and intended challenge conditions.

## 3. Data dictionary and resource index

- [x] Generate `course_data_dictionary` with:
  - `dataset`
  - `variable`
  - `type`
  - `units`
  - `description`
  - `allowed_values`
  - `variant_notes`
- [x] Make it available through `data(course_data_dictionary)`.
- [x] Implement `course_resources()`.
- [x] Include current datasets and descriptive day/topic metadata.
- [x] Add templates as they become available.
- [x] Add aliases as they become available.
- [x] Test that every listed resource exists and every advertised alias resolves.

## 4. Exercise templates

- [x] Add a Day 2 Quarto template under `inst/templates/`.
- [x] Add a Day 3 template for explicit analytical rules.
- [ ] Add a Day 4 template for visualization as representation when the Day 4
  faculty/TA team supplies its requirements.
- [ ] Add a Day 5 template for structured objects and context when the Day 5
  faculty/TA team supplies its requirements.
- [ ] Reconcile the provisional `expression-filtering` template and `day-4`
  alias. They predate the confirmed schedule and must not be advertised as the
  Day 4 exercise.
- [x] Include sections for:
  - biological question
  - prediction
  - analytical specification or consequential AI prompt
  - data inspection
  - analysis code
  - checkpoints
  - result
  - interpretation
  - why I trust this
- [x] Keep the scaffold suggestive, not enforced.
- [x] Implement `copy_template(template, dest = NULL, overwrite = FALSE)`.
- [x] Use descriptive template names as the canonical names.
- [x] Add supported day aliases.
- [x] Default copies to the course project's `exercises/` directory.
- [x] Refuse to overwrite files unless `overwrite = TRUE`.
- [x] Test canonical names, destinations, and overwrite behavior.
- [x] Test aliases when they are added.

## 5. Setup checks and dependencies

- [x] Add the dependencies required for the completed Day 2 and Day 3
  infrastructure, with sensible minimum versions, to `DESCRIPTION`.
- [ ] Add Day 4 and later dependencies only after the responsible instructors
  supply them.
- [x] Keep `DESCRIPTION` as the only course dependency manifest.
- [x] Implement a concise `check_setup()` that checks:
  - R and required package versions
  - RStudio, where detectable
  - Quarto
  - Git, when needed
  - write permissions
  - bundled data loading
  - a simple ggplot
  - a minimal Quarto render
- [x] Test checks through stable public results, not console formatting.

## 6. Vignette and CI

- [x] Add one short getting-started vignette.
- [x] Cover installation, setup checking, project creation, template copying, and bundled data.
- [x] Check R-release on Windows and macOS, and R-devel, R-release, and
  R-oldrel-1 on Linux.
- [x] Add a bundled-data loading check.
- [x] Add a basic plotting smoke test.
- [x] Add a minimal Quarto render.

### Parked

- Seurat smoke testing belongs to the instructor who owns that material.

## 7. Release

- [ ] Test installation in a clean student-like environment.
- [ ] Publish a tagged GitHub release.
- [x] Document the exact installation command.
- [ ] Use patch releases during the course only for genuine blockers.

## Done means

- Public functions are documented and tested through their interfaces.
- Seeded data can be rebuilt reproducibly.
- `R CMD check` passes cleanly.
- Templates render in a clean environment.
- The package contains infrastructure, not course-management material.

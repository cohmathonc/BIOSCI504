source("R/generate-mouse-trial.R")
source("R/generate-mouse-trial-unit-error.R")

mouse_trial_unit_error <- .generate_mouse_trial_unit_error(
  .generate_mouse_trial()
)

dir.create("data", showWarnings = FALSE)
save(
  mouse_trial_unit_error,
  file = "data/mouse_trial_unit_error.rda",
  compress = "xz"
)

source("R/generate-mouse-trial.R")
source("R/generate-mouse-trial-duplicates.R")

mouse_trial_duplicates <- .generate_mouse_trial_duplicates(
  .generate_mouse_trial()
)

dir.create("data", showWarnings = FALSE)
save(
  mouse_trial_duplicates,
  file = "data/mouse_trial_duplicates.rda",
  compress = "xz"
)

source("R/generate-mouse-trial.R")
source("R/generate-mouse-trial-missingness.R")

mouse_trial_missingness <- .generate_mouse_trial_missingness(
  .generate_mouse_trial()
)

dir.create("data", showWarnings = FALSE)
save(
  mouse_trial_missingness,
  file = "data/mouse_trial_missingness.rda",
  compress = "xz"
)

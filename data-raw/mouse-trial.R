source("R/generate-mouse-trial.R")

mouse_trial <- .generate_mouse_trial()

dir.create("data", showWarnings = FALSE)
save(mouse_trial, file = "data/mouse_trial.rda", compress = "xz")

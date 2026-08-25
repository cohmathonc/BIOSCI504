.generate_mouse_trial_unit_error <- function(mouse_trial) {
  unit_error <- mouse_trial$mouse_id == "M020"
  mouse_trial$final_weight_g[unit_error] <-
    mouse_trial$final_weight_g[unit_error] * 1000
  mouse_trial
}

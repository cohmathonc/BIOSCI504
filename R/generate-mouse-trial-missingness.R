.generate_mouse_trial_missingness <- function(mouse_trial) {
  missing_final_ids <- c("M001", "M002", "M003", "M004", "M008")
  mouse_trial$final_weight_g[
    mouse_trial$mouse_id %in% missing_final_ids
  ] <- NA_real_
  mouse_trial
}

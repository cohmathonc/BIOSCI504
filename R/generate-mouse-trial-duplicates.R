.generate_mouse_trial_duplicates <- function(mouse_trial) {
  duplicate_ids <- c("M007", "M019", "M042")
  duplicate_rows <- mouse_trial[
    match(duplicate_ids, mouse_trial$mouse_id),
  ]
  mouse_trial_duplicates <- rbind(mouse_trial, duplicate_rows)

  set.seed(505)
  mouse_trial_duplicates <- mouse_trial_duplicates[
    sample(seq_len(nrow(mouse_trial_duplicates))),
  ]
  rownames(mouse_trial_duplicates) <- NULL
  mouse_trial_duplicates
}

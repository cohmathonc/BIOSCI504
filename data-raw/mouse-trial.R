set.seed(504)

n_mice <- 48L
mouse_id <- sprintf("M%03d", seq_len(n_mice))
cage <- rep(sprintf("C%02d", 1:6), each = 8L)

control_by_cage <- c(4L, 5L, 4L, 5L, 4L, 4L)
treatment <- unlist(
  lapply(
    control_by_cage,
    function(n_control) {
      sample(c(rep("control", n_control), rep("treatment", 8L - n_control)))
    }
  ),
  use.names = FALSE
)

female_by_cage <- c(4L, 4L, 5L, 4L, 4L, 4L)
sex <- unlist(
  lapply(
    female_by_cage,
    function(n_female) {
      sample(c(rep("female", n_female), rep("male", 8L - n_female)))
    }
  ),
  use.names = FALSE
)

batch <- character(n_mice)
batch[treatment == "control"] <- sample(
  c(rep("B01", 9L), rep("B02", 9L), rep("B03", 8L))
)
batch[treatment == "treatment"] <- sample(
  c(rep("B01", 7L), rep("B02", 7L), rep("B03", 8L))
)

cage_effect <- setNames(
  c(-0.35, -0.15, 0, 0.10, 0.25, 0.40),
  sprintf("C%02d", 1:6)
)
batch_effect <- c(B01 = -0.15, B02 = 0, B03 = 0.15)

baseline_weight_g <- rnorm(
  n_mice,
  mean = 23.5 + ifelse(sex == "male", 2.8, 0),
  sd = 0.9
)
weight_change_g <-
  1.2 +
  ifelse(treatment == "treatment", 1.4, 0) +
  cage_effect[cage] +
  batch_effect[batch] +
  rnorm(n_mice, mean = 0, sd = 0.55)

weight_change_g[mouse_id == "M037"] <-
  weight_change_g[mouse_id == "M037"] + 4

final_weight_g <- baseline_weight_g + weight_change_g
baseline_weight_g <- round(baseline_weight_g, 1)
final_weight_g <- round(final_weight_g, 1)

baseline_weight_g[mouse_id == "M012"] <- NA_real_
final_weight_g[mouse_id == "M031"] <- NA_real_

mouse_trial <- data.frame(
  mouse_id,
  treatment,
  sex,
  baseline_weight_g,
  final_weight_g,
  cage,
  batch,
  stringsAsFactors = FALSE
)

dir.create("data", showWarnings = FALSE)
save(mouse_trial, file = "data/mouse_trial.rda", compress = "xz")

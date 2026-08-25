# `mouse_trial` generation

Run these commands from the package root:

```sh
Rscript data-raw/mouse-trial.R
Rscript data-raw/mouse-trial-missingness.R
Rscript data-raw/mouse-trial-duplicates.R
Rscript data-raw/mouse-trial-unit-error.R
```

The script uses seed 504 and generates 48 mice across two treatments, two sexes, six cages, and three batches.

The data-generating model includes:

- a 1.4 g treatment effect on weight change;
- cage effects from -0.35 g to 0.40 g;
- batch effects from -0.15 g to 0.15 g;
- 0.55 g standard deviation for individual weight change;
- a 4 g additional gain for `M037`;
- a missing baseline value for `M012`;
- a missing final value for `M031`.

`weight_change_g` is used to generate the data but is not included in the packaged object.

## Challenge variants

- `mouse_trial_missingness` adds missing final weights for `M001`, `M002`, `M003`, `M004`, and `M008`. It retains the missing final weight for `M031`.
- `mouse_trial_duplicates` repeats `M007`, `M019`, and `M042`, then shuffles rows with seed 505.
- `mouse_trial_unit_error` multiplies the final weight for `M020` by 1,000.

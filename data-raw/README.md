# `mouse_trial` generation

Run `Rscript data-raw/mouse-trial.R` from the package root.

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

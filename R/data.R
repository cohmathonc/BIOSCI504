#' Mouse treatment trial
#'
#' Simulated baseline and final weights for 48 mice in a treatment study.
#'
#' @format A data frame with 48 rows and 7 variables:
#' \describe{
#'   \item{mouse_id}{Unique mouse identifier.}
#'   \item{treatment}{Treatment assignment: \code{control} or \code{treatment}.}
#'   \item{sex}{Recorded sex: \code{female} or \code{male}.}
#'   \item{baseline_weight_g}{Weight before treatment, in grams.}
#'   \item{final_weight_g}{Weight after treatment, in grams.}
#'   \item{cage}{Housing cage identifier.}
#'   \item{batch}{Experimental batch identifier.}
#' }
#' @source Simulated for BIOSCI 504.
#' @examples
#' data(mouse_trial)
#' mouse_trial
"mouse_trial"

sfdnn <- function(y, x, z = NULL, grid, weights, control = sfdnn_control(), seed = NULL) {
  if (!inherits(weights, "sfdnn_weights")) stop("Use spatial_weights() to build the weight object.")
  if (!is.list(x)) x <- list(x)
  n <- length(y)
  if (nrow(weights$W) != n) stop("The weight matrix and the response have different sizes.")
  if (!is.null(seed)) set.seed(seed)
  valid <- sort(sample.int(n, max(2, floor(n * control$validation))))
  fit_rows <- setdiff(seq_len(n), valid)
  
  summaries <- covariate_summaries(x, z, grid, control$n_basis)
  rows_of <- function(rows) lapply(x, function(curves) as.matrix(curves)[rows, , drop = FALSE])
  z_of <- function(rows) if (is.null(z)) NULL else as.matrix(z)[rows, , drop = FALSE]
  
  pilot_rho <- estimate_rho(y[fit_rows], rows_of(fit_rows), z_of(fit_rows), grid,
                            restrict_weights(weights, fit_rows), control$pve, control$bounds)$rho
  pilot_inputs <- spatial_filter(weights, pilot_rho, summaries)
  pilot_scaling <- standardizer(pilot_inputs[fit_rows, , drop = FALSE])
  pilots <- lapply(control$learning_rates, function(rate) {
    network_train(standardize(pilot_inputs[fit_rows, , drop = FALSE], pilot_scaling), y[fit_rows],
                  control$hidden, rate, control$epochs, control$batch, control$patience, seed,
                  standardize(pilot_inputs[valid, , drop = FALSE], pilot_scaling), y[valid])
  })
  chosen <- which.min(vapply(pilots, function(p) p$valid_error, numeric(1)))
  
  first_stage <- estimate_rho(y, x, z, grid, weights, control$pve, control$bounds)
  inputs <- spatial_filter(weights, first_stage$rho, summaries)
  scaling <- standardizer(inputs)
  final <- network_train(standardize(inputs, scaling), y, control$hidden,
                         control$learning_rates[chosen], pilots[[chosen]]$epochs,
                         control$batch, control$patience, seed)
  fitted <- network_forward(final$params, standardize(inputs, scaling))$fitted
  structure(list(params = final$params, scaling = scaling, rho = first_stage$rho,
                 boundary = first_stage$boundary, learning_rate = control$learning_rates[chosen],
                 epochs = pilots[[chosen]]$epochs, fitted = fitted, residuals = y - fitted,
                 summaries = summaries, control = control, grid = grid),
            class = "sfdnn")
}

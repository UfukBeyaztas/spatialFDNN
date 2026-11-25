sfdnn_control <- function(hidden = c(64, 64), n_basis = 7, epochs = 400, batch = 32,
                          patience = 30, learning_rates = c(0.001, 0.01), validation = 0.2,
                          pve = 0.95, bounds = c(-0.99, 0.99)) {
  list(hidden = hidden, n_basis = n_basis, epochs = epochs, batch = batch,
       patience = patience, learning_rates = learning_rates, validation = validation,
       pve = pve, bounds = bounds)
}

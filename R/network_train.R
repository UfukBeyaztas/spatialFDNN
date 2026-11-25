network_train <- function(inputs, y, hidden, learning_rate, epochs, batch, patience, seed,
                          valid_inputs = NULL, valid_y = NULL) {
  if (!is.null(seed)) set.seed(seed)
  params <- network_init(ncol(inputs), hidden)
  first_moment <- second_moment <- lapply(params, function(p) p * 0)
  n <- nrow(inputs)
  batches <- ceiling(n / batch)
  step_count <- 0
  best_error <- Inf
  best_epoch <- 0
  for (epoch in seq_len(epochs)) {
    order <- sample.int(n)
    for (b in seq_len(batches)) {
      rows <- order[seq.int((b - 1) * batch + 1, min(b * batch, n))]
      gradients <- network_gradient(params, inputs[rows, , drop = FALSE], y[rows])
      step_count <- step_count + 1
      first_moment <- Map(function(m, g) 0.9 * m + 0.1 * g, first_moment, gradients)
      second_moment <- Map(function(v, g) 0.999 * v + 0.001 * g^2, second_moment, gradients)
      step <- learning_rate / (1 - 0.9^step_count)
      correction <- 1 - 0.999^step_count
      params <- Map(function(p, m, v) p - step * m / (sqrt(v / correction) + 1e-7),
                    params, first_moment, second_moment)
    }
    if (!is.null(valid_inputs)) {
      valid_error <- mean((valid_y - network_forward(params, valid_inputs)$fitted)^2)
      if (!is.finite(valid_error)) stop("The validation error is not finite.")
      if (valid_error < best_error) {
        best_error <- valid_error
        best_epoch <- epoch
      }
      if (epoch - best_epoch >= patience) break
    }
  }
  list(params = params, epochs = if (is.null(valid_inputs)) epochs else best_epoch,
       valid_error = best_error)
}

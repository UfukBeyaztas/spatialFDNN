# spatialFDNN

spatialFDNN fits spatial functional deep neural networks (SFDNN) in R. The method predicts a scalar response observed at spatial locations from functional predictors, such as weekly weather curves, and from scalar covariates. It was developed for the paper *Spatial Functional Deep Neural Network Model* by Merve Basaran, Ufuk Beyaztas, Han Lin Shang, and Zaher Mundher Yaseen, and the package also contains the data-generating designs of the paper's simulation study.

The full reference manual is in this repository: [spatialFDNN_0.1.0.pdf](spatialFDNN_0.1.0.pdf).

## The idea in a few lines

Let $W$ be a row-standardized spatial weight matrix and $A_\rho = (I - \rho W)^{-1}$. SFDNN assumes that the mean response at site $i$ is an unknown function of the predictors of site $i$ after they have been filtered with $A_\rho$:

$$
E(Y_i \mid X, Z) = m(\tilde v_i), \qquad \tilde v_i = \sum_{i'} a_{\rho, ii'} \, v_{i'},
$$

where $v_{i'}$ collects the functional and scalar predictors of site $i'$. The response at a site therefore depends on the predictors of its neighbors through the weights of the spatial filter. The linear spatial scalar-on-function regression model is a special case.

The fit has two stages. First, $\rho$ is estimated by maximum likelihood in a linear spatial autoregressive working model built on functional principal component scores. Then every functional predictor is summarized by its inner products with a cubic B-spline basis, the summaries and the scalar covariates are filtered with $A_{\hat\rho}$, and a network with a sigmoid hidden layer and a linear hidden layer is trained on the filtered inputs. The learning rate and the stopping epoch are chosen on a random validation set.

The model is not the nonlinear spatial autoregressive model $Y = A_\rho\{g(X, Z) + \epsilon\}$. With a common weight matrix and a common nonzero $\rho$, the two have the same mean for every predictor configuration only when $g$ is affine. Also, when the regression function is nonlinear, the first-stage $\hat\rho$ is the dependence parameter of the linear working model and need not recover the $\rho$ that generated the data. 

## Installation

```r
install.packages("remotes")
remotes::install_github("UfukBeyaztas/spatialFDNN")
```

and load it with

```r
library(spatialFDNN)
```

## A first example

The example below uses the nonlinear filtered design of the simulation study, with strong dependence ($\rho = 0.9$), 500 training sites, and an independent test graph of 1,000 sites. The network has two hidden layers of 64 neurons, as in the paper.

```r
library(spatialFDNN)

train <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
test  <- simulate_sfdnn(1000, design = "nonlinear_filtered", rho = 0.9, seed = 2)

fit <- sfdnn(train$y, train$x, train$z, train$grid, train$weights, seed = 3)
fit

pred <- predict(fit, test$x, test$z, test$weights)
prediction_error(test$y, pred)

# The same measure for the true conditional mean, which gives the noise level
prediction_error(test$y, test$mu)
```

`train$x` is a list of three matrices, one for each functional predictor, with one row per site and one column per grid point. `train$z` holds the three scalar predictors, and `train$weights` is the weight object of the training graph. A fit with 500 sites takes from several seconds to under a minute, depending on how long training runs before it stops early.

## Predicting held-out sites in the same region

When the sites to be predicted lie among sites with observed responses, the model is fitted to the observed sites with the weight matrix restricted to them. The held-out sites are then predicted from the covariates of all sites. The residuals of the observed sites can also be interpolated to the held-out sites under the covariance of the spatial autoregressive working model. This SAR residual correction uses the observed responses, so it is reported separately from the covariate prediction.

```r
dat <- simulate_sfdnn(600, design = "linear_sar", rho = 0.9, seed = 1)

set.seed(2)
held_out <- sort(sample.int(600, 120))
observed <- setdiff(1:600, held_out)

fit <- sfdnn(dat$y[observed], lapply(dat$x, function(m) m[observed, ]),
             dat$z[observed, ], dat$grid,
             restrict_weights(dat$weights, observed), seed = 3)

covariate <- predict(fit, dat$x, dat$z, dat$weights)
corrected <- sar_residual_correction(covariate, dat$y, observed, held_out,
                                     dat$weights, fit$rho)

prediction_error(dat$y[held_out], covariate[held_out])
prediction_error(dat$y[held_out], corrected)
```

## Looking inside the fitted network

The network has no coefficient that can be read off directly, so the package describes the fitted response through perturbations. `perturbation_effect()` changes one predictor, at all sites or at chosen sites and over a chosen part of its domain, and returns the change in the fitted response at every site. A change at a single site also moves the fitted values of its neighbors, which shows the spillover through the spatial filter. These contrasts describe the fitted prediction rule under the chosen weight matrix and are not causal effects.

```r
dat <- simulate_sfdnn(500, design = "nonlinear_filtered", rho = 0.9, seed = 1)
fit <- sfdnn(dat$y, dat$x, dat$z, dat$grid, dat$weights, seed = 2)

# Raise the first functional predictor by one unit on the middle of its domain at every site
mid <- which(dat$grid >= 0.4 & dat$grid <= 0.6)
summary(perturbation_effect(fit, dat$x, dat$z, dat$weights,
                            predictor = 1, delta = 1, points = mid))

# Raise it at site 250 only and look at how the change spreads
local <- perturbation_effect(fit, dat$x, dat$z, dat$weights,
                             predictor = 1, delta = 1, sites = 250)
plot(abs(1:500 - 250), local, xlab = "distance in the site index",
     ylab = "change in the fitted response")
```

`rho_sensitivity()` gives a bound on how much the fitted values of a fixed network can move when the filter uses another value of $\rho$. The bound grows quickly with the strength of dependence. A change of $\rho$ from 0.85 to 0.90 can move the filtered inputs about fifty times more than a change from 0.10 to 0.15.

```r
rho_sensitivity(fit, fit$rho, 0.9)
rho_sensitivity(fit, 0.10, 0.15)$filter_factor
rho_sensitivity(fit, 0.85, 0.90)$filter_factor
```

## Using your own data

Put each functional predictor in a matrix with one row per site and one column per grid point, all on the same grid, and collect these matrices in a list. Scalar covariates go in a matrix with one row per site. For locations given by longitude and latitude, `knn_bisquare_weights()` builds the adaptive bi-square nearest-neighbor matrix used for the county data in the paper. Any other nonnegative matrix with a zero diagonal can be passed to `spatial_weights()`.

```r
# curves: list of site-by-week matrices, covariates: site-by-J matrix,
# weeks: the common grid, coords: longitude and latitude of the sites
w <- knn_bisquare_weights(coords, k = 8)

estimate_rho(yield, curves, covariates, weeks, w)$rho
fit <- sfdnn(yield, curves, covariates, weeks, w, seed = 1)
```

The defaults of `sfdnn_control()` are the settings of the paper: two hidden layers with 64 neurons, seven B-spline basis functions per functional weight, mini-batches of 32, at most 400 epochs with a patience of 30, learning rates 0.001 and 0.01, and 20% of the sites for validation. For a quick look at a new data set, a smaller network is often enough:

```r
quick <- sfdnn_control(hidden = c(16, 16), epochs = 100, patience = 15)
fit <- sfdnn(yield, curves, covariates, weeks, w, control = quick, seed = 1)
```

## Reproducing the simulation designs

`simulate_sfdnn()` generates the three designs of the paper. The linear design is the linear spatial autoregressive model with Gaussian, $t_3$, or centered exponential errors. In the nonlinear SAR design, a nonlinear function of the predictors is computed before the spatial filter is applied. In the nonlinear filtered design, the same function is evaluated at the filtered predictors, which is the structure SFDNN assumes. The study crosses these with 100, 250, and 500 training sites and $\rho$ = 0.1, 0.5, and 0.9, which gives 45 settings:

```r
settings <- rbind(
  expand.grid(design = "linear_sar", error = c("gaussian", "t3", "exponential"),
              n = c(100, 250, 500), rho = c(0.1, 0.5, 0.9), stringsAsFactors = FALSE),
  expand.grid(design = c("nonlinear_sar", "nonlinear_filtered"), error = "gaussian",
              n = c(100, 250, 500), rho = c(0.1, 0.5, 0.9), stringsAsFactors = FALSE))
nrow(settings)
```

The paper evaluates every fit on an independent test graph of 1,000 sites. In the nonlinear designs it also uses 1,000 test sites made of independent graphs of the training size, which `simulate_sfdnn_graphs()` generates. The misspecified weight matrices of the study come from `inverse_distance_weights()` with `type = "truncated"` or `type = "permuted"`.

```r
matched <- simulate_sfdnn_graphs(250, 4, design = "nonlinear_sar", rho = 0.9, seed = 4)
w_truncated <- inverse_distance_weights(500, "truncated")
w_permuted  <- inverse_distance_weights(500, "permuted")
```

## Functions

| Function | Purpose |
|---|---|
| `sfdnn()`, `sfdnn_control()` | Fit the model and set the network and training options |
| `predict()` | Covariate prediction at new or held-out sites |
| `sar_residual_correction()` | Residual correction for held-out sites with observed neighbors |
| `estimate_rho()` | First-stage estimate of $\rho$ from the linear working model |
| `perturbation_effect()` | Change in the fitted response when a predictor is changed |
| `rho_sensitivity()` | Bound on the effect of the value of $\rho$ on the predictions |
| `covariate_summaries()`, `spatial_filter()` | Network inputs and the spatial filter |
| `spatial_weights()`, `restrict_weights()` | Build a row-standardized weight matrix and restrict it to a subset of sites |
| `knn_bisquare_weights()`, `inverse_distance_weights()`, `great_circle_distance()` | Weight matrices for coordinates and for the simulation study |
| `simulate_sfdnn()`, `simulate_sfdnn_graphs()` | Data of the simulation designs |
| `prediction_error()`, `morans_i()` | Prediction error, $R^2$, and Moran's I of residuals |

Every function is documented with its theory and an example in the [reference manual](spatialFDNN_0.1.0.pdf) and in the help pages, for example `?sfdnn`.

## License and contact

spatialFDNN is released under the GPL-3 license. Questions, bug reports, and suggestions are welcome through the [issues page](https://github.com/UfukBeyaztas/spatialFDNN/issues) or by email to Ufuk Beyaztas (ufuk.beyaztas@marmara.edu.tr).

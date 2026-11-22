# Monte Carlo Numerical Integration: Weibull ----
# Coder: Colin Thurow
# Goal: Estimate the area under the Weibull function
# (shape = 1.5, scale = 1) between x = 0 and x = 4 with a Monte Carlo
# simulation. We plot random points in a box around the curve, find
# the proportion that land under the curve, and multiply by the box's
# area. We repeat with 4 different sample sizes (10, 100, 1,000, and 10,000
# random points) and combine the plots into a small multiple to see how
# the estimate improves.
monte_carlo_points <- function(nPoints, xMin, xMax, yMin, yMax) {
  data.frame(
    x = runif(n = nPoints, min = xMin, max = xMax),
    y = runif(n = nPoints, min = yMin, max = yMax)
  )
}

# Step 1: Load packages ----
library(tidyverse)
library(patchwork)

# Step 2: Simulation function ----
# Makes nPoints random points inside the box set by the x and y bounds.
# Returns a data frame with one row per point.
monte_carlo_points <- function(nPoints, xMin, xMax, yMin, yMax) {
  data.frame(
  x = runif(n = nPoints, min = xMin, max = xMax),
  y = runif(n = nPoints, min = yMin, max = yMax)
  )
}

# Step 3: Set the bounds of the box (edit these for a new situation) ----
xMin <- 0
xMax <- 4
yMin <- 0
yMax <- 0.8   # the curve peaks at about 0.75, so 0.8 covers it
boxArea <- (xMax - xMin) * (yMax - yMin)

# Step 4: Wrangling function ----
# Runs the simulation and marks whether each point is under the curve.
make_mc_data <- function(nPoints) {
  monte_carlo_points(nPoints = nPoints,
  xMin = xMin, xMax = xMax,
  yMin = yMin, yMax = yMax) |>
    mutate(underCurve = y <= dweibull(x, shape = 1.5, scale = 1))
}

# Step 5: Plot function ----
# Estimates the area (share of points under the curve x box area),
# then plots the points and the curve with the estimate in the subtitle.
make_mc_plot <- function(nPoints) {
  mcData <- make_mc_data(nPoints = nPoints)
  estArea <- mean(mcData$underCurve) * boxArea
  
  mcData |>
  ggplot(mapping = aes(x = x, y = y, color = underCurve)) +
  geom_point(size = 0.7) +
  stat_function(fun = dweibull,
  args = list(shape = 1.5, scale = 1),
  xlim = c(xMin, xMax),
  color = "black") +
  labs(title = paste0(nPoints, " random points"),
  subtitle = paste0("Estimated area: ", round(estArea, 3)),
  x = "x",
  y = "Density",
  color = "Under curve?") +
  theme_bw()
}

# Step 6: Make one plot for each sample size ----
plot10 <- make_mc_plot(nPoints = 10)
plot100 <- make_mc_plot(nPoints = 100)
plot1000 <- make_mc_plot(nPoints = 1000)
plot10000 <- make_mc_plot(nPoints = 10000)

# Step 7: Combine the four plots into a small multiple ----
plot10 + plot100 + plot1000 + plot10000

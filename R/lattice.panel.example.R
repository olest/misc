library("lattice");

x <- rnorm(100)
y <- x + rnorm(100, sd = 0.5)
f <- gl(2, 50, labels = c("Group 1", "Group 2"))

# plot x vs y in two panels, conditioned on f
xyplot(y ~ x | f)

# same as above, with line at the median
xyplot(y ~ x | f,
panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    panel.abline(h = median(y),
    lty = 2)
})

# with regression line
xyplot(y ~ x | f,
panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    panel.lmline(x, y, col = 2)
})


# http://www.r-bloggers.com/making-back-to-back-histograms/

# with ggplot
library(ggplot2)
df = data.frame(x = rnorm(100), x2 = rnorm(100, mean=2))
g = ggplot(df, aes(x)) + geom_histogram( aes(x = x, y = ..density..),
                                             binwidth = diff(range(df$x))/30, fill="blue") +
geom_histogram( aes(x = x2, y = -..density..), binwidth = diff(range(df$x))/30, fill= "green")
print(g)

## using base
h1 = hist(df$x, plot=FALSE)
h2 = hist(df$x2, plot=FALSE)
h2$counts = - h2$counts
hmax = max(h1$counts)
hmin = min(h2$counts)
X = c(h1$breaks, h2$breaks)
xmax = max(X)
xmin = min(X)
plot(h1, ylim=c(hmin, hmax), col="green", xlim=c(xmin, xmax))
lines(h2, col="blue")
